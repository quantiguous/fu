require 'spec_helper'

module Fu
  describe IncomingFileRecord, type: :model do
    context 'association' do
      it { should belong_to(:incoming_file) }
      it { should have_many(:fm_audit_steps) }
    end
  end
end
