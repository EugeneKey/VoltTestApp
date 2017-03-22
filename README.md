### Регистрация пользователя.

На главной странице нажимаем **Sign_up**
Заполняем необходимые поля.

После аутентификации у пользователя появляется:

    1. Возможность управления своим профилем:
          Profile - просмотр профиля, загрузка аватара
          Edit profile - изменение аутентификационных данных
    2. Возможность создания oauth приложения для доступа к API.

Авторизация для доступа к API осуществляется с помощью oauth приложения, либо через запрос с передачей логина и пароля:

----------
## API
### Аутентификация

    POST /oauth/token.json

Параметры запроса:

     ❏ grant_type: password
     ❏ email
     ❏ password

В ответ получаем json, где имеется поле `access_token`

`access_token` используем в качестве параметра при обращении к API.

### Создание записи

    POST /api/v1/posts.json

Параметры запроса:

    ❏ title
    ❏ body
    ❏ published_at
    
В ответ получаем json с полями:

    ❏ id
    ❏ title
    ❏ body
    ❏ published_at
    ❏ author_nickname
    
Если в запросе нет `published_at`, то записывается текущее время. 
Если передаются не все поля, то ответ содержит одно поле `errors` — массив ошибок.

### Получение записи по id

    GET /api/v1/posts/:post_id.json

Получаем `post` по его `id`, поля в ответе такие же как при запросе **`POST /api/v1/posts.json`**

### Получение списка записей постранично:

    GET /api/v1/posts.json

Параметры запроса:

    ❏ page
    ❏ per_page
    
В ответе список записей отсортированных по полю `published_at`  по убыванию

Поля каждой записи такие же как при запросе **`POST /api/v1/posts.json`**

В заголовках ответа:

    Count-Page - общее количество страниц 
    Count-Record - общее количество записей.

### Аналитический отчет

    POST /api/v1/reports/by_author.json
    
Параметры запроса:

    ❏ start_date — начало интервала
    ❏ end_date — конец интервала
    ❏ email — куда отправить отчёт

Полe в ответе:

    ❏ message: “Report generation started”

После запроса создается задача `ReportGeneratorJob` на генерацию отчёта и помещается в очередь **default**.

После получения данных для отчета, генерируется письмо и отправляется из очередь **mailers**  на email указанный в задаче.

Отчёт в письме представляет собой таблицу со столбцами:

    ❏ Nickname
    ❏ email
    ❏ Posts count - количество записей за период
    ❏ Comments count - количество комментариев за период

Строки в отчёте отсортированы по значению вычисляемому как
(количество постов + количество комментариев/10). 
Письмо состоит из двух частей:

 1. `plain text` где таблица оформлена при помощи **ASCII символов**
 2. `html` где таблица оформлена в виде **HTML таблицы**

Если в параметрах запроса невалидная дата, то из очереди **mailers** отправляется письмо `ReportMailer.error`.
Письмо содержит заголовок: "REPORT: Error on date params"

В теле письма указываются полученные параметры `start_date` и `end_date`

### Development instructions (how to run on local machine)

**System requirements** 

- Unix like OS
- Redis (http://redis.io)
- PostgreSQL (http://postgresql.org)

<details>
  <summary>[open ▾] How to check required software?</summary>

```
$ type rvm
/home/USER/.rvm/bin/rvm

$ type redis-server
/usr/bin/redis-server

$ type psql
/usr/bin/psql
```

</details>

Config files:

  - config/database.yml
 
copy and edit this files from .sample:

```  
cp config/database.yml.sample config/database.yml
```

initial:

```
  bundle update
  rake db:create
  rake db:migrate
```

run app with `foreman`

```
foreman start -f Procfile.dev
```

run test:
```
rspec spec
```

**Finally App is ready to use**

http://localhost:3000