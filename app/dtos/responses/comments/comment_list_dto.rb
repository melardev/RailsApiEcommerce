class CommentListDto

  attr_accessor :comments, :page_meta

  def initialize(comments, articles_count, base_path, page, page_size)
    @comments = comments
    @page_meta = PageMeta.new(comments, articles_count, base_path, page, page_size)
  end
end