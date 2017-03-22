# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def report

    start_date, end_date = 3.month.ago, Time.now

    email = 'test@mail.com'

    raw_data, report_data = {}, []

    post_data = Post.get_report_data(start_date, end_date)
    comment_data = Comment.get_report_data(start_date, end_date)

    post_data.each { |key,value| raw_data[key] = [value, 0] }

    comment_data.each do |key,value|
      if raw_data.key?(key)
        raw_data[key][1] = value
      else
        raw_data[key] = [0, value]
      end
    end

    raw_data.each { |key,value| report_data << raw_data.assoc(key).flatten }

    report_data = report_data.sort { |b,a| (a[2] + a[3]/10.0) <=> (b[2] + b[3]/10.0) }

    ReportMailer.report(report_data, email, start_date.utc, end_date.utc)
  end

  def error
    start_date, end_date = 3.month.ago, Time.now
    email = 'test@mail.com'

    ReportMailer.error(start_date, end_date, email)
  end

end
