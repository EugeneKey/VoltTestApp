class ReportGeneratorJob < ApplicationJob
  queue_as :default

  def perform(start_date, end_date, email)

    if start_date.present? && end_date.present? && start_date.to_time && end_date.to_time

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

      ReportMailer.report(report_data, email, start_date.to_s, end_date.to_s).deliver_later

    else
      params_error = [start_date.to_s,end_date.to_s]
      ReportMailer.error(params_error, email).deliver_later
    end

  end
end
