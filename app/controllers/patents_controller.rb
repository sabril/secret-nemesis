class PatentsController < ApplicationController

  # caches_action :index, :expires_in => 14.days, :cache_path => Proc.new { |c| c.request.url }
  # caches_action :show, :expires_in => 14.days
  
  def index
    # if !params[:browse]
    #   params[:browse]="all"
    # end
    # if params[:browse]!="all"
    #   @patents = Patent.where("application_type=?",params[:browse]).order("filing_date DESC").page(params[:page]).per(50)
    # else
    #   @patents = Patent.order("filing_date DESC").page(params[:page]).per(50)
    # end
    @patents = Patent.search(params[:search], :order => sort_column, :sort_mode => sort_direction).page(params[:page])
  end

  def show
    @patent = Patent.find(params[:id])
    @title = @patent.invention_title
    @meta_description = "A " + @patent.application_type + " patent application filed on " + @patent.filing_date.to_s + " credited to " + @patent.inventor
  end
  
  def advanced_search
    condition = "1=1"
    if params["patent"]
      @patents = Patent.new params["patent"]
      params["patent"].each do |column, content|
        if column == "invention_title"
          condition << " and invention_title like '%#{content}%'" if content != ""
          next
        end
        if column == "inventor"
          condition << " and inventor like '%#{content}%'" if content != ""
          next
        end
        if column == "agent_name"
          condition << " and agent_name like '%#{content}%'" if content != ""
          next
        end
        if column == "applicant_name"
          condition << " and applicant_name like '%#{content}%'" if content != ""
          next
        end
        if column == "application_type"
          condition << " and application_type = '#{content}'" if content != ""
          next
        end
        if column == "application_status"
          condition << " and application_status = '#{content}'" if content != ""
          next
        end
      end
      @patents_result = Patent.where(condition).order(sort_column + " " + sort_direction).page(params[:page])
    else
      @patents = Patent.new
      @patents_result = ""
    end
    
  end
  
  def sort_column
    params[:sort].blank? ? "patents.filing_date" : params[:sort]
  end
  
  def new
    @patent = Patent.new
  end
end
