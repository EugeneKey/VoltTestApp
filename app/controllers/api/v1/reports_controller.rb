class Api::V1::ReportsController < Api::V1::BaseController

  def by_author
    ReportGeneratorJob.perform_later(
          report_params[:start_date],
          report_params[:end_date],
          report_params[:email]
    )

    render json: { message: 'Report generation started' }
  end

  private

  def report_params
    params.permit(:start_date, :end_date, :email)
  end
end