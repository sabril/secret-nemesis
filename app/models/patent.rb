class Patent < ActiveRecord::Base

  include ActionView::Helpers::TextHelper

  before_save :generate_permalink

  def generate_permalink
    namestr = self.invention_title.sub("'s", "s").sub("'S","S")
    namestr = truncate(namestr, :length => 40, :separator => ' ', :omission => '').parameterize
    namestr.sub("-amp-","-and-")
    self.permalink = namestr
  end

end
