require 'rails_helper'

describe 'login page' do
  it 'prompts the user to log in', :js => true do
    visit '/access/login'
    page.should have_content('Hello')
  end
end
