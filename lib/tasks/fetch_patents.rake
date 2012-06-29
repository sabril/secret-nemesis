require 'rubygems'
require 'nokogiri'
require 'mechanize'

task :fetch_patents => :environment do

  agent = Mechanize.new
  agent.keep_alive = false

  start_at = ENV['start_at'].to_i

  url = "http://pericles.ipaustralia.gov.au/ols/auspat/applicationDetails.do?applicationNo=" + i.to_s
  agent.get(url)
  form = agent.page.form
  button = form.button_with(:value => "Accept")
  agent.submit(form, button)

  (2000..2012).each do |year|

    failures = 0

    until i == 909000

      application_no = year.to_s + i.to_s.rjust(6, '0')

      if Patent.find_all_by_application_number(application_no).count == 0 && application_no > start_at

        url = "http://pericles.ipaustralia.gov.au/ols/auspat/applicationDetails.do?applicationNo=" + application_no.to_s
        agent.get(url)

        puts (application_no)

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
          failures = 0
        else
          puts "     -- not enough fields fetched; not saved"
          failures = failures + 1
        end

      else

        puts application_no.to_s + " -- already exists in database"

      end

      if failures == 20
        i = i + 1000
        puts "failed 20 times; skipping 1000 records"
        failures = 0
      else
        i = i + 1
      end

    end

  end

end
