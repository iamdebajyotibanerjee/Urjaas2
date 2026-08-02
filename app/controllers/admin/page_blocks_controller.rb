# app/controllers/admin/page_blocks_controller.rb
module Admin
  class PageBlocksController < ApplicationController
    before_action :set_landing_page
    before_action :set_page_block, only: [ :update, :destroy ]

    def update
      cleaned_params = normalize_content_items(page_block_params)

      if @page_block.update(cleaned_params)
        respond_to do |format|
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block updated." }
          format.turbo_stream
        end
      else
        redirect_to edit_admin_landing_page_path(@landing_page), alert: "Failed to update block."
      end
    end

    def reorder
      # Expecting params[:block_ids] = ["12", "5", "19", ...]
      block_ids = params[:block_ids] || []

      # Atomically update position for each block ID based on its index
      block_ids.each_with_index do |id, index|
        @landing_page.page_blocks.where(id: id).update_all(position: index + 1)
      end

      head :ok
    end

    private

    def set_landing_page
      @landing_page = LandingPage.find(params[:landing_page_id])
    end

    def set_page_block
      @page_block = @landing_page.page_blocks.find(params[:id])
    end

    def page_block_params
      params.require(:page_block).permit(:position, :block_type, content: {})
    end

    def normalize_content_items(params_hash)
      return params_hash unless params_hash[:content] && params_hash[:content][:items]

      # Convert {"0" => {...}, "1" => {...}} hash to an Array [{...}, {...}]
      if params_hash[:content][:items].is_a?(ActionController::Parameters) || params_hash[:content][:items].is_a?(Hash)
        params_hash[:content][:items] = params_hash[:content][:items].values
      end

      params_hash
    end
  end
end
