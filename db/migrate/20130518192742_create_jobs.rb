class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :job_title
      t.text :job_description
      t.string :job_sport
      t.string :job_gender
      t.string :job_city
      t.string :job_state
      t.string :job_email
      t.integer :job_zip_code
      t.references :user
 
      t.timestamps

    end
  end
end
