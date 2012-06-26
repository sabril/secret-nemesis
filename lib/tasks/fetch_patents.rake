require 'rubygems'
require 'nokogiri'
require 'mechanize'

task :fetch_patents => :environment do

  agent = Mechanize.new
  agent.keep_alive = false

  i = 2012902575

  url = "http://pericles.ipaustralia.gov.au/ols/auspat/applicationDetails.do?applicationNo=" + i.to_s
  agent.get(url)
  form = agent.page.form
  button = form.button_with(:value => "Accept")
  agent.submit(form, button)

  until i == 2012900001

    if Patent.find_all_by_application_number(i).count == 0

      url = "http://pericles.ipaustralia.gov.au/ols/auspat/applicationDetails.do?applicationNo=" + i.to_s
      agent.get(url)
      
      puts (i.to_s)
      
      patent = Patent.new
      begin
        patent.source_url = url
        patent.application_number = agent.page.at("#content :nth-child(2) .col6:nth-child(1) tr:nth-child(1) td:nth-child(2)").text.strip
        patent.application_type = agent.page.at("#content :nth-child(2) .col6:nth-child(1) tr:nth-child(1) td:nth-child(4)").text.strip
        patent.application_status = agent.page.at("#content :nth-child(2) tr:nth-child(2) td:nth-child(2)").text.strip
        patent.under_opposition = agent.page.at(".col6:nth-child(2) td:nth-child(2)").text.strip
        patent.invention_title = agent.page.at(".col2:nth-child(3) td:nth-child(2)").text.strip
        patent.inventor = agent.page.at(".col2:nth-child(4) td:nth-child(2)").text.strip
        patent.agent_name = agent.page.at(":nth-child(5) td:nth-child(2)").text.strip
        patent.address_for_service = agent.page.at(":nth-child(5) .colspan3").text.strip
        patent.filing_date = agent.page.at(":nth-child(6) td:nth-child(2)").text.strip
        patent.applicant_name = agent.page.at(":nth-child(4) .col6 tr:nth-child(1) td:nth-child(2)").text.strip
        patent.applicant_address = agent.page.at(".col6:nth-child(1) .colspan3").text.strip
        patent.old_name = agent.page.at(".colspan5").text.strip
      rescue
      end
      if !patent.application_number.nil? && !patent.invention_title.nil?
        patent.save!
        puts "     -- saved"
      else
        puts "     -- not enough fields fetched; not saved"
      end

    else
      
      puts i.to_s + " -- already exists in database"
      
    end 
    
    i=i-1

  end

end
