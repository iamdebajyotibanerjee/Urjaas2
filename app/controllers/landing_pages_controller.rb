# app/controllers/landing_pages_controller.rb
class LandingPagesController < ApplicationController
  # Render without admin sidebar / navbar layout
  layout "landing_page"

  def index
    @landing_pages = LandingPage.published
  end

  def show
    param_value = params[:id] || params[:slug]

    # Allow previewing drafts if requested via admin context/preview parameter,
    # otherwise strictly require published status.
    scope = allow_draft_preview? ? LandingPage.all : LandingPage.published

    @landing_page = scope.find_by(id: param_value) || scope.find_by(slug: param_value)

    # Raise proper 404 error if page is missing
    raise ActiveRecord::RecordNotFound, "Landing Page not found or not published" unless @landing_page

    # Fetch page blocks strictly ordered by position for rendering
    @page_blocks = @landing_page.page_blocks.order(position: :asc)
  end

  private

  def allow_draft_preview?
    # Temporarily allow draft viewing if preview param is passed,
    # or if coming from the admin editor referer.
    params[:preview] == "true" || request.referer&.include?("/admin/")
  end
end
