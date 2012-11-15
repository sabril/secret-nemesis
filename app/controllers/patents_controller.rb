class PatentsController < ApplicationController
  
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
  end
  
end
