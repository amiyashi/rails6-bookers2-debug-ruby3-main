class SearchesController < ApplicationController
  #全てのアクション前に、ログインしているか確認
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @keyword = params[:keyword]
    @method = params[:method]

    if @model  == "user"
      @results = User.search_for(@keyword, @method)
    else
      @results = Book.search_for(@keyword, @method)
    end
  end

end