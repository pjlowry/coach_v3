class AddCoachingExperienceAndPlayingExperienceToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :coaching_experience, :text
    add_column :profiles, :playing_experience, :text

  end
end
