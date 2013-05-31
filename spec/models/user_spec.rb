require 'spec_helper'

describe User do 
  context 'mass assignment' do 
    it {should allow_mass_assignment_of :email}
    it {should allow_mass_assignment_of :password}
    it {should allow_mass_assignment_of :password_confirmation}
    it {should allow_mass_assignment_of :remember_me}
  end
end