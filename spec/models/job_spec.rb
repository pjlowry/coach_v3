require 'spec_helper'

describe Job do 
  context 'associations' do 
    it {should belong_to :user}
  end
  
  context 'validations' do
    it {should validate_presence_of :job_title}
    it {should validate_presence_of :job_description}
    it {should validate_presence_of :job_city}
    it {should validate_presence_of :job_zip_code}
    it {should validate_presence_of :job_state}
    it {should validate_presence_of :job_sport}
    it {should validate_presence_of :job_email}
  end

   context 'accessibility' do 
     it {should allow_mass_assignment_of :job_gender}
     it {should allow_mass_assignment_of :job_sport}
     it {should allow_mass_assignment_of :job_zip_code}
     it {should allow_mass_assignment_of :job_title}
     it {should allow_mass_assignment_of :job_description}
     it {should allow_mass_assignment_of :job_qualifications}
     it {should allow_mass_assignment_of :job_state}
     it {should allow_mass_assignment_of :job_city}
     it {should allow_mass_assignment_of :job_email}  
     it {should allow_mass_assignment_of :job_address}  
     it {should allow_mass_assignment_of :latitude}  
     it {should allow_mass_assignment_of :longitude}  
  end
end