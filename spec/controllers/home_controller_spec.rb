require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #index' do
    before { get :index }

    it 'is successful' do
      expect(response).to be_successful
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end
end
