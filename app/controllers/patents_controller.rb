class PatentsController < ApplicationController
  
  def index
    @patents = Patent.order("filing_date DESC").all
  end

  def show
    @patent = Patent.find(params[:id])
  end
  
end
