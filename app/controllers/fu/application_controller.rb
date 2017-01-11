module Fu
  class ApplicationController < ::ApplicationController
    protect_from_forgery
        
    before_filter :authenticate_user!
    before_filter :block_inactive_user!
  end
end
