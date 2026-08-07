# app/controllers/admin/landing_pages_controller.rb
module Admin
  class LandingPagesController < ApplicationController
    before_action :set_landing_page, only: [ :edit, :update, :destroy, :toggle_publish ]

    def index
      @landing_pages = LandingPage.order(created_at: :desc)
    end

    def edit
      # Live side-by-side builder view
    end

    def create
      @landing_page = LandingPage.new(landing_page_params)

      if @landing_page.save
        redirect_to edit_admin_landing_page_path(@landing_page), notice: "Landing page created! Start adding blocks."
      else
        redirect_to admin_landing_pages_path, alert: @landing_page.errors.full_messages.to_sentence
      end
    end

    def update
      if @landing_page.update(landing_page_params)
        redirect_to edit_admin_landing_page_path(@landing_page), notice: "Landing page settings updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @landing_page.destroy
      redirect_to admin_landing_pages_path, notice: "Landing page deleted successfully."
    end

    def toggle_publish
      # Leverages your enum methods (published? / draft! / published!)
      if @landing_page.published?
        @landing_page.draft!
      else
        @landing_page.published!
      end

      redirect_back fallback_location: admin_landing_pages_path, notice: "Status updated to #{@landing_page.status.titleize}."
    end

    private

    def set_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    def landing_page_params
      # Swapped :published for :status
      params.require(:landing_page).permit(:title, :slug, :status)
    end
  end
end
