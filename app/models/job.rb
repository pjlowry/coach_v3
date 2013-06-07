class Job < ActiveRecord::Base
  include PgSearch

  validates :job_title, :job_distance_search, :job_sport, :job_city, :job_state, :job_zip_code, :job_description, :job_email, :user_id, :presence => true
  attr_accessible :job_title, :job_sport, :job_gender, :job_city, :job_state, :job_zip_code, :job_description, :job_email, :user_id, :job_address, :latitude, :longitude

  GENDER = ["Male", "Female", "Male or Female"]
  STATE = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA",
"ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH",
"OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
  belongs_to :user

  pg_search_scope :job_search, against: [:job_sport],
                  using: [:tsearch, :dmetaphone, :trigram],
                  ignoring: :accents
  

  before_validation do |job|
    job.job_address = [job_city, job_state, job_zip_code].compact.join(', ')
  end

  before_validation do |job|
    job.job_sport = job_sport.titleize
  end

  # scope :desc, order("jobs.created_at DESC")

  # before_save :titlecase

  geocoded_by :job_address
  after_validation :geocode, :if => :job_address_changed?

  def self.text_search(job_query)
    if job_query.present?
      job_query = job_query.downcase
      # search(query)
      rank = <<-RANK
        ts_rank(to_tsvector(job_sport), plainto_tsquery(#{sanitize(job_query)}))
      RANK
    where("to_tsvector('english', job_sport) @@ :q", q: job_query.gsub(" ", " | ")).order("#{rank} ASC")
    else
      scoped
    end
  end

end