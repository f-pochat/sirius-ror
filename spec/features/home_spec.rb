require 'rails_helper'

RSpec.describe 'Home' do
  describe 'GET #index' do
    it 'displays the welcome message' do
      visit root_path
      expect(page).to have_content('Welcome')
    end
  end
end
