class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
        if @article.save
          turbo_stream.replace("private_articles" , 
          partial: "articles/card_view",
          locals:{
            article: @article
        })
        else
          render :new, status: :unprocessable_entity
      end
  end

   
  def correct_user
    @article = current_user.article.find_by(id: params[:id])
    redirect_to root_path, notice: "Not Authorized To Edit This article" if @article.nil?
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
        turbo_stream.replace("#{helpers.dom_id(@article)}_article" , 
        partial: "articles/card_view",
        locals:{
          article: @article
      })
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    turbo_stream.remove("#{helpers.dom_id(@article)}_article")
    redirect_to root_path, status: :see_other
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :status, :user_id)
  end
  def set_article
    @article = Article.find(params[:id])
  end
end
