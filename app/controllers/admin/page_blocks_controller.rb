# app/controllers/admin/page_blocks_controller.rb
module Admin
  class PageBlocksController < ApplicationController
    before_action :set_landing_page
    before_action :set_page_block, only: [ :update, :destroy ]

    def create
      @page_block = @landing_page.page_blocks.build(page_block_params)
      @page_block.position ||= (@landing_page.page_blocks.maximum(:position) || 0) + 1

      respond_to do |format|
        if @page_block.save
          format.turbo_stream
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block added successfully." }
        else
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), alert: "Failed to add block." }
        end
      end
    end

    def update
      respond_to do |format|
        if @page_block.update(page_block_params)
          format.turbo_stream
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block updated successfully." }
        else
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), alert: "Failed to update block." }
        end
      end
    end

    def destroy
      @page_block.destroy

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block deleted successfully." }
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

    def set_page_block
      @page_block = @landing_page.page_blocks.find(params[:id])
    end

    def page_block_params
      permitted = params.require(:page_block).permit(:block_type, :position)

      if params[:page_block][:content_json].present?
        begin
          permitted[:content] = JSON.parse(params[:page_block][:content_json])
        rescue JSON::ParserError
          permitted[:content] = {}
        end
      elsif params[:page_block][:content_data].present?
        permitted[:content] = params[:page_block][:content_data].permit!.to_h
      elsif params[:page_block][:content].present?
        if params[:page_block][:content].is_a?(ActionController::Parameters) || params[:page_block][:content].is_a?(Hash)
          permitted[:content] = params[:page_block][:content].permit!.to_h
        else
          permitted[:content] = params[:page_block][:content]
        end
      end

      permitted
    end
  end
end
