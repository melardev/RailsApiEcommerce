class ProductCreateOrEditDto < BaseRequestDto

  def initialize(params)
    super(params)
    @sanitized_params = {}
    name = params[:name]
    description = params[:description]
    tags = params[:tags]
    categories = params[:categories]
    price = params[:price]
    stock = params[:stock]
    images = params[:images]

    if name
      @sanitized_params.merge!(:name => name)
    end

    if description
      @sanitized_params.merge!(:description => description)
    end

    if price
      @sanitized_params.merge!(:price => price)
    end

    if stock
      @sanitized_params.merge!(:stock => stock)
    end

  if images
    @sanitized_params.merge!(:images => images)
  end

    if tags
      @sanitized_params.merge!(:tags => tags)
    end

    if categories
      @sanitized_params.merge!(:categories => categories)
    end
  end

  def has_tags?
    @sanitized_params.has_key?(:tags)
  end

  def get_tags
    @sanitized_params[:tags] || []
  end

  def get_images
    @sanitized_params[:images] || []
  end

  def has_categories?
    @sanitized_params.has_key?(:categories)
  end

  def get_categories
    @sanitized_params[:categories] || []
  end

  def get_params
    @sanitized_params.except(:tags, :categories, :images)
  end
end