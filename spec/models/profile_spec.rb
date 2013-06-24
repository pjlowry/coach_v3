require 'spec_helper'

describe Profile do 
  context 'associations' do 
    it {should belong_to :user}
  end
  
  context 'validations' do
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
    it {should validate_presence_of :user_id}
    it {should validate_presence_of :city}
    it {should validate_presence_of :street}
    it {should validate_presence_of :zip_code}
    it {should validate_presence_of :state}
    it {should validate_presence_of :bio}
    it {should validate_presence_of :sport}
    it {should validate_presence_of :contact_email}
    it {should validate_presence_of :coaching_experience}
    it {should validate_presence_of :playing_experience}
  end

   context 'accessibility' do 
       it {should allow_mass_assignment_of :gender}
       it {should allow_mass_assignment_of :picture}
       it {should allow_mass_assignment_of :sport}
       it {should allow_mass_assignment_of :zip_code}
       it {should allow_mass_assignment_of :bio}
       it {should allow_mass_assignment_of :user_id}
       it {should allow_mass_assignment_of :first_name}
       it {should allow_mass_assignment_of :last_name}
       it {should allow_mass_assignment_of :state}
       it {should allow_mass_assignment_of :city}
       it {should allow_mass_assignment_of :street}
       it {should allow_mass_assignment_of :contact_email}
       it {should allow_mass_assignment_of :coaching_experience}
       it {should allow_mass_assignment_of :playing_experience}
  end
end