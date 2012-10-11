require 'rubygems'
require 'nokogiri'
require 'mechanize'

task :fetch_patents => :environment do

  agent = Mechanize.new
  agent.keep_alive = false

  start_at = ENV['start_at'].to_i
  start_at_year = start_at.to_s[0..3].to_i
  start_at_i = start_at.to_s[4..start_at.to_s.length].to_i

  puts "start_at_year: " + start_at_year.to_s
  puts "start_at_i: " + start_at_i.to_s

  url = "http://pericles.ipaustralia.gov.au/ols/auspat/applicationDetails.do?applicationNo=2012900644"
  agent.get(url)
  form = agent.page.form
  button = form.button_with(:value => "Accept")
  agent.submit(form, button)

  (start_at_year..2012).each do |year|

    failures = 0

    if year==start_at_year
      i = start_at_i
    else
      i = 0
    end

    puts "skipping to " + start_at_year.to_s + start_at_i.to_s

    until i >= 909000

      application_no = year.to_s + i.to_s.rjust(6, '0')

      if Patent.find_all_by_application_number(application_no).count == 0
        begin
          url = "http://pericles.ipaustralia.gov.au/ols/auspat/applicationDetails.do?applicationNo=" + application_no.to_s
          agent.get(url)

          puts (application_no)

          patent = Patent.new

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

          if !patent.application_number.nil? && !patent.invention_title.nil?
            patent.save!
            puts "     -- saved"
            failures = 0
          else
            puts "     -- not enough fields fetched; not saved"
            failures = failures + 1
          end
        rescue
        end
      else

        puts application_no.to_s + " -- already exists"

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
