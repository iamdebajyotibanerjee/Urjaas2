module Admin
  class PageBlocksController < ApplicationController
    # Create a new page block
    def create
      @landing_page = LandingPage.find(params[:landing_page_id])
      @page_block = @landing_page.page_blocks.build(page_block_params)
      @page_block.position = (@landing_page.page_blocks.maximum(:position) || 0) + 1

      if @page_block.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to edit_admin_landing_page_path(@landing_page) }
        end
      end
    end

    # Destroy a page block
    def destroy
      @landing_page = LandingPage.find(params[:landing_page_id])
      @page_block = @landing_page.page_blocks.find(params[:id])
      @page_block.destroy

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to edit_admin_landing_page_path(@landing_page) }
      end
    end

    # Reorder page blocks
    def reorder
      @landing_page = LandingPage.find(params[:landing_page_id])

      # Batch update positions based on the array of block IDs sent from JavaScript
      params[:block_ids].each_with_index do |id, index|
        @landing_page.page_blocks.where(id: id).update_all(position: index + 1)
      end

      head :ok
    end

    private

    def page_block_params
      params.require(:page_block).permit(:block_type).tap do |whitelisted|
        whitelisted[:content] = params[:page_block][:content]&.to_unsafe_h || {}
      end
    end
  end
end
