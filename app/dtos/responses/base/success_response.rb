class SuccessResponse
  attr_accessor :full_messages

  def initialize(messages)
    if messages.instance_of? Array
      @full_messages = messages
    else
      @full_messages = [messages]
    end
  end
end