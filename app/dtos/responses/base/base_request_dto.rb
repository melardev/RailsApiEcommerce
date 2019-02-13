class BaseRequestDto
  def initialize(params)
    @errors = {}
  end

  def add_error(symbol, message)
    if @errors.has_key?(symbol)
      @errors[symbol].append message
    else
      @errors.merge!({symbol => [message]})
    end
  end

  def get_errors
    @errors
  end

  def full_messages
    @errors.values
  end
end