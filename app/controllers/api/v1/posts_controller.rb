class Api::V1::PostsController < Api::V1::BaseController
  before_action :load_post, only: :show
  before_action :load_posts, only: :index

  def index
    respond_with @posts
  end

  def show
    respond_with @post
  end

  def create
    respond_with :api, :v1, @post = Post.create(
      post_params.merge(author: current_resource_owner)
    )
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at)
  end

  def load_post
    @post = Post.find(params[:id])
  end

  def load_posts
    page, per_page = [params[:page].to_i, params[:per_page].to_i]

    # default value per_page if params per_page not valid
    per_page = 25 unless per_page > 0

    @posts = Post.by_published.page(page).per(per_page)

    response.headers['Count-Page'] = @posts.total_pages
    response.headers['Count-Record'] = @posts.total_count
  end

end