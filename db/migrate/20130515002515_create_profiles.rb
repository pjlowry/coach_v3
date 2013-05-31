class CreateProfiles < ActiveRecord::Migration
  def change 
    create_table :profiles do |t|
       t.string :first_name
       t.string :last_name
       t.string :sport
       t.string :gender
       t.string :city
       t.string :address
       t.string :state
       t.string :contact_email
       t.text :bio
       t.integer :zip_code
       t.references :user

       t.timestamps

     end
  end
end
