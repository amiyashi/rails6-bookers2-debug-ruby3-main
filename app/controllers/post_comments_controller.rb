class PostCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.post_comments.new(post_comment_params)
    # comment = PostComment.new(post_comment_params)
    # comment.user_id = current_user.id
    @comment.book_id = @book.id
    @comment.save
    # redirect_to book_path(book)
  end

  def destroy
    @book = Book.find(params[:book_id])
    # @post_comment = PostComment.find(params[:book_id])
    PostComment.find(params[:id]).destroy
    # redirect_to book_path(params[:book_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
