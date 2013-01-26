class PagesController < ApplicationController

  # caches_action :home, :expires_in => 14.days

  def home
    @title = "Patent Lookup Australia"
    @meta_description = "Robust search of over 1 million Australian patents, including provisional patents."
    @patents_new = Patent.search(:order => :created_at, :page => 1, :per_page => 10)
    @patents_trend = Patent.search(:order => "@random ASC", :page => 1, :per_page => 10)
  end

end
