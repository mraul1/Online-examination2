class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy, :take_exam, :check]
  before_action :authenticate_teacher!, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,only: [:take_exam]

  @questions = Question.all
  if @questions.length >= 15
    @@exam_questions = Question.order('RANDOM()').limit(15)
  else
    @@exam_questions = Question.order('RANDOM()')
  end
  
  respond_to :html

  def index
    @exams = Exam.all
    respond_with(@exams)
  end

  def show
    @questions = Question.where(exam_id: @exam.id)
    respond_with(@exam)
  end

  def new
    @exam = Exam.new
    respond_with(@exam)
  end

  def edit
  end

  def create
    @exam = Exam.new(exam_params)
    @exam.save
    respond_with(@exam)
  end

  def update
    @exam.update(exam_params)
    respond_with(@exam)
  end

  def destroy
    @exam.destroy
    respond_with(@exam)
  end

  def take_exam
    if session[:count].nil?
      session[:count] = 0
    end
    @step = @@exam_questions[session[:count]] 
  end

  def check    
    session[:correct] ||= 0
    session[:total_possible_marks] ||= 0
    session[:user_marks] ||= 0
    if params[:answer] == @@exam_questions[session[:count]].answer
      session[:correct] += 1
      session[:user_marks] += @@exam_questions[session[:count]].marks
    end
    session[:total_possible_marks] += @@exam_questions[session[:count]].marks
    session[:count] += 1
    @step = @@exam_questions[session[:count]]
    if @step.nil?
      redirect_to exam_current_result_path(@exam) 
    else
      redirect_to :action => "take_exam" 
    end 
  end

  def result
    @exam = Exam.find(params[:exam_id])
    @correct = session[:correct]
    @total_marks = session[:user_marks]
    @total_possible_marks = session[:total_possible_marks]
    @possible = @@exam_questions.length

    @result = Result.create(exam_id: params[:exam_id],user_id: current_user.id,score: @total_marks,max_score: @total_possible_marks)
    
    session.clear
    @questions = Question.all
    if @questions.length >= 15
      @@exam_questions = Question.order('RANDOM()').limit(15)
    else
      @@exam_questions = Question.order('RANDOM()')
    end
  end
  
  private
    def set_exam
      @exam = Exam.find(params[:id])
    end

    def exam_params
      params.require(:exam).permit(:name)
    end
end
