class QuestionsController < ApplicationController
  before_filter :authenticate_teacher!
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_exam

  respond_to :html

  def index
    @questions = Question.where(exam_id: @exam.id)
    respond_with(@questions)
  end

  def show
    respond_with(@exam)
  end

  def new
    @question = Question.new
    respond_with(@question)
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.exam_id = @exam.id
    @question.save
    respond_with(@exam)
  end

  def update
    @question.update(question_params)
    respond_with(@exam)
  end

  def destroy
    @question.destroy
    respond_with(@exam)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def set_exam
      @exam = Exam.find(params[:exam_id])
    end

    def question_params
      params.require(:question).permit(:content, :answer, :marks, options_attributes:[ :id, :content, :question_id])
    end
end
