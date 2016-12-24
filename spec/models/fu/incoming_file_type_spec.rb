require 'spec_helper'

module Fu
  describe IncomingFileType, type: :model do
    context 'validation' do
      [:sc_service_id, :code, :name].each do |att|
        it { should validate_presence_of(att) }
      end

      it do
        Factory(:incoming_file_type)
        should validate_uniqueness_of(:code).scoped_to(:sc_service_id)
      end

    end
  end
end
