class ErrorResponse

  attr_accessor :errors, :full_messages

  def initialize(errors)
    if errors.instance_of? Hash
      @errors = errors

      @full_messages = []
      errors.values.each {
          |message|
        if message.instance_of? Array # if {key: [value]}
          @full_messages.concat(message)
        else # if {key: 'value'} or int or other
          @full_messages.append message
        end
      }
    elsif errors.instance_of? ActiveModel::Errors
      @errors = errors
      @full_messages = errors.full_messages
    elsif errors.instance_of? String
      @errors = {error: errors}
      @full_messages = [errors]
    else
      raise 'invalid arg'
    end
  end
end