class CreatePatents < ActiveRecord::Migration
  def change
    create_table :patents do |t|
      t.integer :id
      t.integer :application_number
      t.string :application_type
      t.string :application_status
      t.string :under_opposition
      t.string :proceeding_type
      t.string :invention_title
      t.string :inventor
      t.string :agent_name
      t.string :address_for_service
      t.string :filing_date
      t.string :associated_companies
      t.string :applicant_name
      t.string :applicant_address
      t.string :old_name

      t.timestamps
    end
  end
end
