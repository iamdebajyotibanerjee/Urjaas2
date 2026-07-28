# app/controllers/admin/page_blocks_controller.rb
module Admin
  class PageBlocksController < ApplicationController
    before_action :set_landing_page

    def create
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

    def update
      @page_block = @landing_page.page_blocks.find(params[:id])

      if @page_block.update(page_block_params)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block updated!" }
        end
      else
        render status: :unprocessable_entity
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
      permitted = params.require(:page_block).permit(:block_type)

      if params[:page_block][:content].present?
        # Extract raw nested parameters and normalize indexed keys into Arrays
        raw_content = params[:page_block][:content].to_unsafe_h
        permitted[:content] = normalize_json_content(raw_content)
      end

      permitted
    end

    # Recursively converts hashes with sequential numeric keys ("0", "1", "2") into standard Arrays
    def normalize_json_content(value)
      case value
      when Hash
        if value.keys.present? && value.keys.all? { |k| k.to_s =~ /\A\d+\z/ }
          value.keys.sort_by(&:to_i).map { |k| normalize_json_content(value[k]) }
        else
          value.transform_values { |v| normalize_json_content(v) }
        end
      when Array
        value.map { |v| normalize_json_content(v) }
      else
        value
      end
    end
  end
end
