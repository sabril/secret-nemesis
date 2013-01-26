class Patent < ActiveRecord::Base
  attr_accessible :application_number, :application_type, :application_status, :under_opposition, :proceeding_type, :invention_title, :inventor, :agent_name, :address_for_service, :filing_date, :associated_companies, :applicant_name, :applicant_address, :old_name, :created_at, :updated_at
  
  include ActionView::Helpers::TextHelper

  before_save :generate_permalink


  define_index do
    indexes application_number
    indexes application_type
    indexes application_status
    indexes applicant_name
    indexes invention_title
    indexes inventor
    indexes agent_name
    
    has created_at, updated_at, filing_date
    has app_type, :as => :application_type, :type => :string
    has app_status, :as => :application_status, :type => :string
  end
  
  
  def generate_permalink
    namestr = self.invention_title.sub("'s", "s").sub("'S","S")
    namestr = truncate(namestr, :length => 40, :separator => ' ', :omission => '').parameterize
    namestr.sub("-amp-","-and-")
    self.permalink = namestr
  end

end
