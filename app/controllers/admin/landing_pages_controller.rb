# app/controllers/admin/landing_pages_controller.rb
module Admin
  class LandingPagesController < ApplicationController
    before_action :set_landing_page, only: [ :edit, :update, :destroy, :toggle_publish ]

    def edit
      @new_block = @landing_page.page_blocks.build
    end

    def update
      if @landing_page.update(landing_page_params)
        redirect_to edit_admin_landing_page_path(@landing_page), notice: "Landing page updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @landing_page.destroy
      redirect_to admin_landing_pages_path, notice: "Landing page deleted successfully."
    end

    def toggle_publish
      if @landing_page.published?
        @landing_page.draft!
        @landing_page.update(published_at: nil)
        flash[:notice] = "Page reverted to Draft status."
      else
        @landing_page.published!
        @landing_page.update(published_at: Time.current)
        flash[:notice] = "Page published live successfully!"
      end

      redirect_to edit_admin_landing_page_path(@landing_page)
    end

    private

    def set_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    def landing_page_params
      params.require(:landing_page).permit(:title, :slug, :status)
    end
  end
end
