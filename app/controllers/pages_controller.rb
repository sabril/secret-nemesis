class PagesController < ApplicationController

  # caches_action :home, :expires_in => 14.days

  def home
    @title = "Patent Lookup Australia"
    @meta_description = "Robust search of over 1 million Australian patents, including provisional patents."
  end

end
