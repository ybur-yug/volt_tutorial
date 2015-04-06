if ENV['BROWSER']
  require 'spec_helper'

  describe 'Todo List', type: :feature do
    it 'should have the list title' do
      visit '/'
      expect(page).to have_content('Todos')
    end
  end
end
