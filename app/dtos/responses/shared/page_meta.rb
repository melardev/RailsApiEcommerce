class PageMeta

  attr_accessor :has_next_page, :requested_page_size, :current_items_count, :current_page, :has_prev_page, :next_page_url, :offset,
                :page_count, :total_items_count, :next_page_number, :prev_page_number, :prev_page_url

  def initialize(collection, total_items_count, base_path, page, page_size)
=begin
    json.has_prev_page @page.has_prev_page
    json.has_next_page @page.has_next_page

    json.offset @page.offset

    json.requested_page_size @page.requested_page_size
    json.current_page_size @page.current_page_size

    json.next_page_number @page.next_page_number
    json.prev_page_number @page.prev_page_number

    json.prev_page_url @page.prev_page_url
    json.next_page_url @page.next_page_url

    json.total_items_count @page.total_items_count
    json.page_count @page.page_count
=end

    @offset = (page - 1) * page_size
    @requested_page_size = page_size
    @current_items_count = collection.size
    @total_items_count = total_items_count
    @current_page = page
    # Force the result of / to be float, with one .to_f is enough
    @page_count = (@total_items_count.to_f / page_size.to_f).ceil

    if @page_count >= @current_page
      @has_next_page = true
    else
      @has_next_page = false
    end
    if @current_page <= 1
      @has_prev_page = false
    else
      @has_prev_page = true
    end

    if @has_next_page
      @next_page_number = @current_page + 1
      @next_page_url = format("%s?page_size=%d&page=%d", base_path, page_size, @current_page + 1)
    else
      @next_page_number = @current_page
      @next_page_url = format("%s?page_size=%d&page=%d", base_path, page_size, @current_page)
    end

    if @has_prev_page
      @prev_page_number = @current_page - 1
      @prev_page_url = format("%s?page_size=%d&page=%d", base_path, page_size, @current_page - 1)
    else
      @prev_page_number = @current_page
      @prev_page_url = format("%s?page_size=%d&page=%d", base_path, page_size, @current_page)
    end


  end

end
