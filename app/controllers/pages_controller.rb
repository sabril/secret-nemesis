class PagesController < ApplicationController

  caches_action :home, :expires_in => 14.days

  def home

  end

end
