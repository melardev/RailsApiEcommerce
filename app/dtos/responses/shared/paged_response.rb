class PagedResponse < BasePagedDto
  attr_accessor :resources

  def initialize(resources, resources_count, base_path, page, page_size)
    super(resources, resources_count, base_path, page, page_size)
    @resources = resources
  end
end