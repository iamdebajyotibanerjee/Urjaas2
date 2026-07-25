module Admin
  class LandingPagesController < ApplicationController
    def edit
      @landing_page = LandingPage.find(params[:id])
      @new_block = @landing_page.page_blocks.build
    end
  end
end
