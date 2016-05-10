class ArticlesController < ApplicationController
    before_filter :require_login, except: [:index, :show]

	def index
		@articles = Article.all
	end

	def show
		@article = Article.find(params[:id])
        @article.increment_view_counter
		@comment = Comment.new
		@comment.article_id = @article.id
    end

	def new
		@article = Article.new
	end

	def create
		@article = Article.create(article_params)
        if @article.valid?
		    flash.notice = "Article '#{@article.title}' created!"
            redirect_to article_path(@article)
        else
        	render 'new'
        end
	end

	def destroy
		@article = Article.find(params[:id])
        @article.tags.each do |tag|
            if tag.articles.length <= 1 
                tag.destroy
            end
        end
		@article.destroy
        redirect_to articles_path
        flash.notice = "Article '#{@article.title}' deleted!"
    end 

    def edit
    	@article = Article.find(params[:id])
    end

    def update
    	@article = Article.find(params[:id])
    	@article.update(article_params)
    	if @article.save
            flash.notice = "Article '#{@article.title}' updated!"
            redirect_to article_path(@article)
        else
            render 'edit'
        end
        
    end

    private 

    def article_params
    	params.require(:article).permit(:title, :body, :tag_list, :image)
    end
end
