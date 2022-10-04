require 'rails_helper'

RSpec.describe Doorkeeper::Application, type: :model do
  before { @app = build(:doorkeeper_application) }
  context 'Doorkeeper applications' do
    before { @app.save }
    it 'Should create app credientials' do
      expect(@app).to be_valid
    end
  end
end
