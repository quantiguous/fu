# encoding: utf-8
require 'carrierwave/processing/mime_types'

module Fu
  class IncomingFileUploader < CarrierWave::Uploader::Base
    include CarrierWave::MimeTypes

    process :set_content_type

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      if Rails.env == "production"
        ENV['CONFIG_FILE_UPLOAD_PATH']
      else
        "uploads"
      end
    end

    def extension_white_list
      Fu::IncomingFile::ExtensionList
    end
  end
end
