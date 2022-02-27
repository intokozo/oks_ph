# require 'carrierwave'
require 'carrierwave-aws'
require 'carrierwave/sequel'

CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV.fetch('S3_BUCKET_NAME') # for AWS-side bucket access permissions config, see section below
  config.aws_acl    = 'private'

  # The maximum period for authenticated_urls is only 7 days.
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  # Set custom options such as cache control to leverage browser caching.
  # You can use either a static Hash or a Proc.
  # config.aws_attributes = -> { {
  #   expires: 1.week.from_now.httpdate,
  #   cache_control: 'max-age=604800'
  # } }

  config.aws_credentials = {
    access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    region:            ENV.fetch('AWS_REGION'), # Required
  }

  # Optional: Signing of download urls, e.g. for serving private content through
  # CloudFront. Be sure you have the `cloudfront-signer` gem installed and
  # configured:
  # config.aws_signer = -> (unsigned_url, options) do
  #   Aws::CF::Signer.sign_url(unsigned_url, options)
  # end
end

class PhotoUploader < CarrierWave::Uploader::Base
  # include CarrierWave::ImageOptimizer
  # include CarrierWave::MiniMagick

  storage :aws

  def extension_allowlist
    ['jpg', 'jpeg', 'png']
  end
  
  def size_rang
    0..5.megabytes
  end

  # process resize_to_fit: [512, 512]
  # process optimize: [{ quality: 75 }]

  # version :small do
  #   process resize_to_fit: [85, 85]
  #   # process optimize: [{ quality: 75 }]
  # end

  def store_dir
    'img/photos/'
  end

  def filename
    "photo-#{Time.now.to_i}"
  end
end

def upload_ava(file)
  File.open("#{settings.public_folder}/img/ava.jpeg", 'wb') do |f|
    f.write(file.read)
  end
end
