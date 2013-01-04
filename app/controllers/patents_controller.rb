class PatentsController < ApplicationController

  caches_action :index, :expires_in => 14.days, :cache_path => Proc.new { |c| c.request.url }
  caches_action :show, :expires_in => 14.days
  
  def index
    if !params[:browse]
      params[:browse]="all"
    end
    if params[:browse]!="all"
      @patents = Patent.where("application_type=?",params[:browse]).order("filing_date DESC").page(params[:page]).per(50)
    else
      @patents = Patent.order("filing_date DESC").page(params[:page]).per(50)
    end

  end

  def show
    @patent = Patent.find(params[:id])
    @title = @patent.invention_title
    @meta_description = "A " + @patent.application_type + " patent application filed on " + @patent.filing_date.to_s + " credited to " + @patent.inventor
  end
  
end
