# app/controllers/admin/page_blocks_controller.rb
module Admin
  class PageBlocksController < ApplicationController
    before_action :set_landing_page

    def create
      # Calculate the next position number automatically
      next_position = @landing_page.page_blocks.maximum(:position).to_i + 1

      @page_block = @landing_page.page_blocks.build(page_block_params)
      @page_block.position = next_position

      if @page_block.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block added!" }
        end
      else
        redirect_to edit_admin_landing_page_path(@landing_page), alert: "Could not add block."
      end
    end

    def destroy
      @page_block = @landing_page.page_blocks.find(params[:id])
      @page_block.destroy

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("page_block_#{@page_block.id}") }
        format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block deleted!" }
      end
    end

    def reorder
      params[:block_ids].each_with_index do |id, index|
        @landing_page.page_blocks.where(id: id).update_all(position: index + 1)
      end

      head :ok
    end

    private

    def set_landing_page
      @landing_page = LandingPage.find(params[:landing_page_id])
    end

    def page_block_params
      params.require(:page_block).permit(:block_type)
    end
  end
end
