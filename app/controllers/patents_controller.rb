class PatentsController < ApplicationController
  
  def index
    @patents = Patent.order("filing_date DESC").page(params[:page]).per(50)
  end

  def show
    @patent = Patent.find(params[:id])
  end
  
end
