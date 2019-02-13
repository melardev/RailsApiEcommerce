class BasePagedDto

  attr_accessor :page_meta
  def initialize(resources, resources_count, base_page, page, page_size)
    @page_meta = PageMeta.new(resources, resources_count, base_page, page, page_size)
  end
end