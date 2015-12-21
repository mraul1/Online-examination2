class ResultsController < ApplicationController
	before_action :set_exam
	before_filter :authenticate_teacher!

	def index
		@results = Result.where(exam_id: @exam.id).order('score DESC')
		respond_to do |format|
			format.html
			format.csv { send_data @results.to_csv }
			format.xls { send_data @results.to_csv(col_sep: "\t") }
		end
	end

	def user_id
	end

	private
		def set_exam
			@exam = Exam.find(params[:exam_id])
		end

		def result_params
			params.require(:result).permit(:exam_id, :user_id, :score, :max_score)
		end
end
