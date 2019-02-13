class CommentsController < ApplicationController
  before_action :authorize!, only: [:create, :update, :destroy]
  before_action :set_product!
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :ensure_ownership, only: [:update, :destroy]
  # GET /comments
  # GET /comments.json
  def index

    page = params[:page] || 1
    page_size = params[:page_size] || 8

    comments = Comment.where(product: @product)
    products_count = Comment.count
    comments = comments.order(created_at: :desc).offset(page_size * (page - 1)).limit(page_size)
    @dto = PagedResponse.new(comments, products_count, self.request.path, page, page_size)
    render 'comments/index'
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  def create
    dto = CommentRequestDto.new(params)
    if dto.valid?
      @comment = @product.comments.new(content: dto.content, user: @current_user, product: @product)
      @comment.user = @current_user

      if @comment.save
        render :show
      else
        @dto = ErrorResponse.new({create: 'Problems saving the comment'})
        render 'shared/errors'
      end
    else
      @dto = ErrorResponse.new(dto.get_errors)
      render 'shared/errors'
    end
  end


  # PATCH/PUT /comments/1
  def update
    dto = CommentRequestDto.new(params)
    if dto.valid?
      if @comment.update(content: dto.content)
        render :show
      else
        # render :json, success: false, messages: {full_messages: 'Failed to update comment'}
        @dto = ErrorResponse.new({db: 'Something weird happend'})
        render 'shared/errors'
      end
    else
      @dto = ErrorResponse.new(dto.get_errors)
      render 'shared/errors'
    end

  end


  def destroy
    if @comment.destroy
      # render json: {success: true, errors: {full_messages: ['Article deleted successfully']}}
      render_success('Deleted successfully')
    else
      render json: {success: false, errors: {article: 'Permission denied'}}, status: :permission_denied
      render_error({delete: 'Operation failed'})
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:content, :product_id, :user_id)
  end


  def set_product!
    # check if id is id or slug
    if !!(params[:product_id] =~ /\A[-+]?[0-9]+\z/)
      # is integer, so id, get by id
      @product = Product.find(params[:product_id])
    else
      @product = Product.find_by(slug: params[:product_id])
    end
  end

  def ensure_ownership
    # If the user does not worn the article or he is not admin
    if @comment.user == @current_user || @current_user.is_admin?
    else
      render_error('Permission denied')
    end
  end
end
