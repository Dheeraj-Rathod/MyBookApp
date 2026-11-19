module Api
  module V1
    class BooksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_book,
                    only: %i[show update destroy cover_image remove_cover_image]

      def index
        books = current_user.books.order(created_at: :desc)
        render json: books.map { |book| book_response(book) }
      end

      def show
        render json: book_response(@book)
      end

      def create
        book = current_user.books.new(book_params)

        if book.save
          render json: book_response(book), status: :created
        else
          render json: { errors: book.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @book.update(book_params)
          render json: book_response(@book)
        else
          render json: { errors: @book.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @book.destroy!
        head :no_content
      end

      def cover_image
        if params[:file].blank?
          return render json: { error: "File is required" },
                        status: :unprocessable_entity
        end

        @book.cover_image.attach(params[:file])

        render json: book_response(@book)
      end

      def remove_cover_image
        @book.cover_image.purge
        head :no_content
      end

      private

      def set_book
        @book = current_user.books.find(params[:id])
      end

      def book_response(book)
        book.as_json.merge(
          cover_image_url: cover_image_url(book)
        )
      end

      def cover_image_url(book)
        return nil unless book.cover_image.attached?

        rails_blob_url(
          book.cover_image,
          host: request.base_url
        )
      end

      def book_params
        params.require(:book).permit(
          :title,
          :author,
          :description,
          :isbn,
          :published_year
        )
      end
    end
  end
end