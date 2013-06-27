CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: "AKIAJ3ORFA54CEADRMLQ",
    aws_secret_access_key: "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"
  }
  config.fog_directory = "coachatlas-profile-pictures"
  config.fog_public = true
end