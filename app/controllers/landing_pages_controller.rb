class LandingPagesController < ApplicationController
  def index
  end
  def show
    param_value = params[:id] || params[:slug]

    # Look up by ID if param_value is numeric, or by slug
    @landing_page = LandingPage.find_by(id: param_value) ||
                    LandingPage.find_by(slug: param_value)

    # Raise proper 404 error if neither match
    raise ActiveRecord::RecordNotFound, "Landing Page not found for '#{param_value}'" unless @landing_page
  end
end
