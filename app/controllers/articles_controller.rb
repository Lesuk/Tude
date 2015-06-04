class ArticlesController < ApplicationController
  before_action :authenticate_user!,
                  only: [:new, :create, :edit, :update, :destroy, :recommended, :favorites, :mine, :favorite, :like]
  after_action :record_article_progress, only: [:show]
  after_action :record_user_view, only: [:show]

  add_breadcrumb("Edut", '/')

  [:index, :popular, :top, :favorites, :recommended, :mine].each do |action|
    define_method action do
      load_categories
      set_page_params
      set_page_size
      @articles ||= method("load_#{action}_articles".to_sym).call(set_page_size)
      add_breadcrumb("Articles", nil)
      render :index
    end
  end

  def show
    load_article_with_categories
    check_enrollment
    user_progress
    load_course_articles
    set_commentable
    load_comments
    add_breadcrumbs(["Articles", articles_path], [@article.category_name, category_path(@article.category)], [@article.title, nil])
  end

  def new
    build_article
    load_main_categories
    load_categories
    @courses = current_user.courses
    @sections = []
  end

  def create
    build_article
    save_article(true) or render 'new'
  end

  def edit
    load_article
    load_categories
    @courses = current_user.courses
    @sections = @article.course.sections
  end

  def update
    load_article
    build_article
    save_article or render 'edit'
  end

  def destroy
    load_article
    @article.destroy
    redirect_to articles_url
  end

  def favorite
    load_article
    @favorited = current_user.bookmarks?(@article)
    if @favorited
      current_user.unbookmark(@article)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.bookmark(@article)
      track_activity(current_user, 'favorited', @article)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

  def like
    load_article
    @liked = current_user.likes?(@article)
    if @liked
      current_user.unlike(@article)
      respond_to do |format|
        format.html {redirect_to :back}
        format.js
      end
    else
      current_user.like(@article)
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    end
  end

  def sort
    params[:article].each_with_index do |id, index|
      Article.where(id: id).update_all({position: index+1})
    end
    render nothing: true
  end

  # Action for updating sections for related course
  def update_sections
    @sections = Section.where("course_id = ?", params[:course_id])
    respond_to do |format|
      format.js
    end
  end

private

  def load_articles
    @articles ||= article_scope.published.to_a
  end

  def load_index_articles(page_size)
    article_scope.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(page_size)
  end

  def load_popular_articles(page_size)
    article_scope.includes(:category).published.in_category(params[:category]).order_popular.page(params[:page]).per(page_size)
  end

  def load_top_articles(page_size)
    articles_array = article_scope.top_sorted_array(params[:category])
    Kaminari.paginate_array(articles_array).page(params[:page]).per(page_size)
  end

  def load_favorites_articles(page_size)
    current_user.bookmarked_articles.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(page_size)
  end

  def load_recommended_articles(page_size)
    ids = current_user.recommended_articles.map{ |a| a.id }
    article_scope.includes(:category).in_array(ids).published.in_category(params[:category]).order_desc.page(params[:page]).per(page_size)
  end

  def load_mine_articles(page_size)
    current_user.articles.includes(:category).published.in_category(params[:category]).order_desc.page(params[:page]).per(page_size)
  end

  def load_article
    @article ||= article_scope.friendly.find(params[:id])
  end

  def load_article_with_categories
    @article ||= article_scope.includes(:category).friendly.find(params[:id])
  end

  def load_categories
    @categories ||= Category.includes(:subcategories).main_categories
  end

  def load_course_articles
    @course_articles ||= @article.course.articles if @article.course_id
  end

  def load_comments
    @comments ||= @commentable.comments.includes(:user, :commentable, {subcomments: :user}).main_comments
  end

  def set_commentable
    @commentable ||= @article
  end

  def set_page_params
    @page_params ||= params.slice(:pagesize, :category, :page, :view)
  end

  def set_page_size
    params[:pagesize] ? params[:pagesize] : 8
  end

  def check_enrollment
    @enrolled ||= current_user.try(:enrolled?, @article.course_id) if user_signed_in? && @article.course_id
  end

  def user_progress
    @user_progress ||= @enrolled ? @article.course.user_progress(current_user) : {}
  end

  def build_article
    @article ||= current_user.articles.build
    @article.attributes = article_params
  end

  def save_article(track = false)
    if @article.save
      track_activity(@article, 'create', @article.course) if track
      current_user.subscribe(@article)
      flash_message :success, "Article has been saved"
      redirect_to @article
    end
  end

  def article_params
    article_params = params[:article]
    article_params ? article_params.permit(:title, :description, :body, :status, :category_id, :course_id,
          :section_id, :youtube_id, :video_duration, :demo_link, :github_link) : {}
    #params.require(:article).permit(:title, :description, :body, :status, :slug, :category_id, :course_id)
  end

  def article_scope
    Article.where(nil)
  end

  def record_article_progress
    current_user.pass_article!(@article, @user_progress) if @enrolled
  end

  def record_user_view
    View.set_view(@article, request.remote_ip)
  end
end
