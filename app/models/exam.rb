class Exam < ActiveRecord::Base
	has_many :questions, dependent: :destroy
end
