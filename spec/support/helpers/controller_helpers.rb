module ControllerHelpers
  extend ActiveSupport::Concern

  included do
    routes { Fu::Engine.routes }
  end
end
