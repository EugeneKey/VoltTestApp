class ReportMailer < ApplicationMailer

  def report(data, email, start_date, end_date)
    @data = data
    @ascii_table = Terminal::Table.new headings: ['Nickname', 'email', 'Posts count', 'Comments count'], rows: data
    @start_date = start_date
    @end_date = end_date

    mail to: email, subject: "REPORT: Activity statistic for period range from #{start_date} to #{end_date}"
  end

  def error(start_date, end_date, email)
    @start_date = start_date
    @end_date = end_date
    mail to: email, subject: "REPORT: Error on date params"
  end
end