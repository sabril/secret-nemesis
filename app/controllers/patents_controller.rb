class PatentsController < ApplicationController

  # caches_action :index, :expires_in => 14.days, :cache_path => Proc.new { |c| c.request.url }
  # caches_action :show, :expires_in => 14.days
  
  def index
    @title = "Patent Lookup Australia - Browse Patents"
    # if !params[:browse]
    #   params[:browse]="all"
    # end
    # if params[:browse]!="all"
    #   @patents = Patent.where("application_type=?",params[:browse]).order("filing_date DESC").page(params[:page]).per(50)
    # else
    #   @patents = Patent.order("filing_date DESC").page(params[:page]).per(50)
    # end
    @search_query = params[:search] || ""
    if params[:advanced] == "true"
      @patents_search = Patent.new
      search_query = ""
      params["patent"].each do |column, content|
        if column == "invention_title"
          search_query << " @invention_title #{params[:patent][:invention_title]}" if content != ""
          next
        end
        if column == "inventor"
          search_query << " @inventor #{params[:patent][:inventor]}" if content != ""
          next
        end
        if column == "agent_name"
          search_query << " @agent_name #{params[:patent][:agent_name]}" if content != ""
          next
        end
        if column == "applicant_name"
          search_query << " @applicant_name #{params[:patent][:applicant_name]}" if content != ""
          next
        end
        if column == "application_type"
          search_query << " @application_type #{params[:patent][:application_type]}" if content != ""
          next
        end
        if column == "application_status"
          search_query << " @application_status #{params[:patent][:application_status]}" if content != ""
          next
        end
      end
      if params[:patent][:created_at] != "" and params[:patent][:updated_at] != ""
        # @patents = Patent.search(search_query, :with => {:filing_date => Date.parse(params[:patent][:created_at].gsub(/, */, '-') )..Date.parse(params[:patent][:updated_at].gsub(/, */, '-') )}, :match_mode => :extended, :ignore_errors => true, :order => sort_column, :sort_mode => sort_direction).page(params[:page])
        @patents = Patent.search(search_query, :with => {:filing_date => Date.parse(params[:patent][:created_at].gsub(/, */, '-') )..Date.parse(params[:patent][:updated_at].gsub(/, */, '-') )}, :match_mode => :extended, :ignore_errors => true, :order => sort_column, :sort_mode => sort_direction).page(params[:page])
      else
        @patents = Patent.search(search_query, :match_mode => :extended, :ignore_errors => true, :order => sort_column, :sort_mode => sort_direction).page(params[:page])
      end
    elsif params[:filtered] == "true"
      @patents_search = Patent.new params[:patent]
      search_query = ""
      params["patent"].each do |column, content|
        if column == "application_type"
          search_query << " @application_type #{params[:patent][:application_type].reject{|a| a.blank?}.join(' | ')}" if content != [""]
          next
        end
        if column == "application_status"
          search_query << " @application_status #{params[:patent][:application_status].reject{|a| a.blank?}.join(' | ')}" if content != [""]
          next
        end
      end
      search_query = params[:search] + " " + search_query unless params[:search].blank?
      if params[:patent][:created_at] != "" and params[:patent][:updated_at] != ""
        # @patents = Patent.search(search_query, :with => {:filing_date => Date.parse(params[:patent][:created_at].gsub(/, */, '-') )..Date.parse(params[:patent][:updated_at].gsub(/, */, '-') )}, :match_mode => :extended, :ignore_errors => true, :order => sort_column, :sort_mode => sort_direction).page(params[:page])
        @patents = Patent.search(search_query, :with => {:filing_date => Date.parse(params[:patent][:created_at].gsub(/, */, '-') )..Date.parse(params[:patent][:updated_at].gsub(/, */, '-') )}, :match_mode => :extended, :ignore_errors => true, :order => sort_column, :sort_mode => sort_direction).page(params[:page])
      else
        @patents = Patent.search(search_query, :match_mode => :extended, :ignore_errors => true, :order => sort_column, :sort_mode => sort_direction).page(params[:page])
      end
    else
      @patents_search = Patent.new
      @patents = Patent.search(params[:search], :order => sort_column, :sort_mode => sort_direction).page(params[:page])
    end
    @q = params[:search]
  end

  def show
    @patent = Patent.find(params[:id])
    @patents_related = Patent.search("#{@patent.invention_title} #{@patent.inventor} #{@patent.agent_name}", :without => {:id => @patent.id }, :match_mode => :any, :page => 1, :per_page => 5, :field_weights => { :invention_title =>10, :inventor => 15, :agent_name => 10 })
    patents_related_inventor = Patent.search(" @inventor #{@patent.inventor}", :ignore_errors => true, :match_mode => :extended, :without => {:id => @patent.id },:order => "@random ASC", :page => 1, :per_page => 5)
    if patents_related_inventor.length > 0 && @patent.inventor != "Not Given"
      @patents_related_title = "Patent by same inventor"
      @patents_related_result = patents_related_inventor
    else
      patents_related_agent = Patent.search(" @agent_name #{@patent.agent_name}", :ignore_errors => true, :match_mode => :extended, :without => {:id => @patent.id }, :order => "@random ASC", :page => 1, :per_page => 5) 
      if patents_related_agent.length > 0
        @patents_related_title = "Patent by same agent"
        @patents_related_result = patents_related_agent
      else
        @patents_related_title = ""
        @patents_related_result = []
      end
    end
    @title = @patent.invention_title
    @meta_description = "A " + @patent.application_type + " patent application filed on " + @patent.filing_date.strftime("%d %B %Y") + " credited to " + @patent.inventor
  end
  
  def advanced_search
    @title = "Patent Lookup Australia - Advanced Search"
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
