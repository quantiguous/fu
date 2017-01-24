module Fu
  class IncomingFilePolicy < ApplicationPolicy
    def new?      
      user.has_role? :editor or user.has_role? :tester
    end

    def approve?      
      user.has_role? :supervisor or user.has_role? :tester
    end

    def generate_response_file?
      user.has_role? :supervisor or user.has_role? :tester
    end

    def reject?      
      user.has_role? :supervisor or user.has_role? :tester
    end

    def process_file?      
      user.has_role? :supervisor or user.has_role? :tester
    end

    def reset?      
      user.has_role? :supervisor or user.has_role? :tester
    end

    def override_records?      
      user.has_role? :editor or user.has_role? :tester
    end

    def skip_records?      
      user.has_role? :editor or user.has_role? :tester
    end

    def approve_restart?      
      user.has_role? :editor or user.has_role? :tester
    end

    def destroy?      
      user.has_role? :editor or user.has_role? :tester or user.has_role? :supervisor
    end
  end
end