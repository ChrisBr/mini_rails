class ArticlesController < Rulers::Controller
  def show
    @article = Article.find(params['id'])
  end

  def index
    @articles = Article.all
  end

  def create
    @article = Article.create(params)
  end
end
