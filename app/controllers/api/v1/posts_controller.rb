class Api::V1::PostsController < Api::V1::BaseController

  def index
    head :ok
  end

  def show
    head :ok
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

end