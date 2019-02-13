class CommentRequestDto < BaseRequestDto
  attr_accessor :content

  def initialize(params)
    @content = ERB::Util.html_escape params[:content]
    @errors = {}
  end

  def valid?
    cv = content_valid?
    cv
  end

  def content_valid?
    has_errors = false
    if @content.blank?
      add_error(:content, 'Content can not be empty')
      return false
    end
    if @content.length <= 1
      add_error(:content, 'Comment should be at lesat chars long')
      has_errors = true
    end
    if has_errors
      false
    else
      true
    end
  end
end