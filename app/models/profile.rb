class Profile < ActiveRecord::Base

  acts_as_gmappable

  validates :first_name, :last_name, :city, :state, :street, :sport, :zip_code, :bio, :user_id, :contact_email, :coaching_experience, :playing_experience, :presence => true
  attr_accessible :first_name, :last_name, :name, :picture, :city, :state, :street, :gender, :sport, :zip_code, :bio, :coaching_experience, :playing_experience, :user_id, :created_at, :contact_email, :address, :longitude, :latitude
  
  mount_uploader :picture, PictureUploader

  belongs_to :user

  GENDER = ['Male', 'Female', 'Decline to Answer']
  STATE = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA",
          "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH",
          "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

  include PgSearch
  pg_search_scope :search, 
                  :against => [:sport],
                  :using => [:tsearch, :dmetaphone, :trigrams],
                  :ignoring => :accents
            

  before_validation do |profile|
    profile.address = [street, city, state, zip_code].compact.join(', ')
  end

  before_validation do |profile|
    profile.sport = sport.titleize
    profile.first_name = first_name.titleize
    profile.last_name = last_name.titleize
    profile.city = city.titleize
  end
  # before_save :titlecase

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  

  def self.text_search(query)
    if query.present?
      query = query.downcase

      # search(query)
      rank = <<-RANK
        ts_rank(to_tsvector(sport), plainto_tsquery(#{sanitize(query)}))
      RANK
    where("to_tsvector('english', sport) @@ :q", q: query).order("#{rank} ASC")
    else
      scoped
    end
  end

  def gmaps4rails_address
    address
  end

  # def self.list_sports
  #   Profile.select(:sport).map(&:sport).uniq.sort
  # end

end