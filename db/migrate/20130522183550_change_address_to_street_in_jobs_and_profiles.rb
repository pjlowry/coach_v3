class ChangeAddressToStreetInJobsAndProfiles < ActiveRecord::Migration
  def change 
    rename_column :profiles, :address, :street
  end
end
