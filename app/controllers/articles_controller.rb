class ArticlesController < ApplicationController
  include Paginable
  skip_before_action :authorize!, only: [:index, :show]

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def show
    article = Article.find(params[:id])
    render json: serialize.new(article)

  end

  def serialize
    ArticleSerializer
  end

end