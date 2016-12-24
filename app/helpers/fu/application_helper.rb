module Fu
  module ApplicationHelper
    def has_route? options
      Rails.application.routes.routes.map{|route| route.defaults}.include?(options)
    end

    def raw_file_content(file_content_str)
      file_content = nil
      file_content = file_content_str.gsub(/^\s+|\n\s+/, "\n") if file_content_str
      file_content
    end
  end
end
