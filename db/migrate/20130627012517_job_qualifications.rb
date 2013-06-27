class JobQualifications < ActiveRecord::Migration
  def change
    add_column :jobs, :job_qualifications, :text
  end
end
