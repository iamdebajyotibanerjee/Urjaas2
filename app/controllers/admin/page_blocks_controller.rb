module Admin
  class PageBlocksController < ApplicationController
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

    private

    def page_block_params
      params.require(:page_block).permit(:block_type).tap do |whitelisted|
        whitelisted[:content] = params[:page_block][:content]&.to_unsafe_h || {}
      end
    end
  end
end
