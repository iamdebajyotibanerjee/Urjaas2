# app/controllers/admin/page_blocks_controller.rb
module Admin
  class PageBlocksController < ApplicationController
    before_action :set_landing_page
    before_action :set_page_block, only: [ :update, :destroy ]

    def create
      @page_block = @landing_page.page_blocks.build(page_block_params)
      @page_block.position ||= (@landing_page.page_blocks.maximum(:position) || 0) + 1

      respond_to do |format|
        if valid_image_uploads? && @page_block.save && attach_block_images
          format.turbo_stream
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block added successfully." }
        else
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), alert: "Failed to add block." }
        end
      end
    end

    def update
      respond_to do |format|
        if valid_image_uploads? && @page_block.update(page_block_params) && attach_block_images
          format.turbo_stream
          format.html { redirect_to edit_admin_landing_page_path(@landing_page), notice: "Block updated successfully." }
        else
          format.turbo_stream { render :update, status: :unprocessable_entity }
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
      permitted = params.require(:page_block).permit(:block_type, :position, :rich_content).to_h

      # Extract and convert content parameters securely
      raw_content = params[:page_block][:content_json] ||
                    params[:page_block][:content_data] ||
                    params[:page_block][:content]

      if raw_content.present?
        if raw_content.is_a?(String)
          begin
            permitted["content"] = JSON.parse(raw_content)
          rescue JSON::ParserError
            permitted["content"] = {}
          end
        elsif raw_content.respond_to?(:permit)
          # Strips out rich_content if it accidentally leaks into the content hash
          content_hash = raw_content.to_unsafe_h
          content_hash.delete("rich_content")
          permitted["content"] = content_hash
        elsif raw_content.is_a?(Hash)
          permitted["content"] = raw_content.except(:rich_content, "rich_content")
        end
      end

      if permitted["content"].is_a?(Hash) && permitted["content"]["items"].is_a?(Hash)
        permitted["content"]["items"] = permitted["content"]["items"]
          .sort_by { |index, _item| index.to_i }
          .map(&:last)
      end

      permitted
    end

    def valid_image_uploads?
      uploads = params.dig(:page_block, :images)
      return true if uploads.blank?

      uploads.each_value do |upload|
        next if upload.blank?

        unless upload.content_type.to_s.start_with?("image/") && upload.size <= 10.megabytes
          @page_block.errors.add(:base, "Choose an image no larger than 10 MB.")
          return false
        end
      end

      true
    end

    def attach_block_images
      uploads = params.dig(:page_block, :images)
      return true if uploads.blank?

      content = @page_block.parsed_content.deep_stringify_keys
      items = content["items"]
      items = (items.is_a?(Hash) ? items.values : Array(items)).map do |item|
        item.is_a?(Hash) ? item : {}
      end

      uploads.each do |key, upload|
        next if upload.blank?

        upload.tempfile.rewind
        blob = ActiveStorage::Blob.create_and_upload!(
          io: upload.tempfile,
          filename: upload.original_filename,
          content_type: upload.content_type
        )
        @page_block.images.attach(blob)

        if key.to_s == "hero"
          content["image_signed_id"] = blob.signed_id
        elsif items[key.to_i]
          items[key.to_i]["image_signed_id"] = blob.signed_id
        end
      end

      content["items"] = items if content.key?("items")
      @page_block.update!(content: content)

      retained_blob_ids = [ content["image_signed_id"], *items.map { |item| item["image_signed_id"] } ]
        .compact
        .filter_map { |signed_id| ActiveStorage::Blob.find_signed(signed_id)&.id }

      @page_block.images.attachments.each do |attachment|
        attachment.purge unless retained_blob_ids.include?(attachment.blob_id)
      end

      true
    rescue ActiveRecord::RecordInvalid, ActiveStorage::Error, IOError => error
      @page_block.errors.add(:base, "Image upload failed: #{error.message}")
      false
    end
  end
end
