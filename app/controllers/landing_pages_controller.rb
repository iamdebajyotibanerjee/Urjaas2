class LandingPagesController < ApplicationController
  def index
  end
  def show
    @landing_page = LandingPage.find_by!(slug: params[:slug])
  end
end
