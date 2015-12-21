json.array!(@questions) do |question|
  json.extract! question, :id, :content, :answer, :marks
  json.url question_url(question, format: :json)
end
