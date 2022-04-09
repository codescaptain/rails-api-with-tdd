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

  def create
    article = Article.new(article_params)
    if article.valid?

    else
      render json: { "errors": errors(article) }, status: :unprocessable_entity
    end

  end

  private

  def article_params
    ActionController::Parameters.new
  end

  def errors(article)
    errors = []
    article.errors.each do |attr, msg|
      errors << {
        source: { pointer: "/data/attributes/#{attr.to_s}" },
        detail: msg
      }
    end
    errors
  end

end