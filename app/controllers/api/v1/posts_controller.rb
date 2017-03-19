class Api::V1::PostsController < Api::V1::BaseController
  before_action :load_post, only: :show

  def index
    head :ok
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

end