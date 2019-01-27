require 'rails_helper'
require 'support/factory_bot'

RSpec.feature 'User fields are validated' do
  given(:user_without_email) { build(:user_without_email) }

  scenario 'Email is not present' do
    expect(user_without_email.save).to eq(false)
  end

  scenario 'Email is present' do
    user_without_email.email = "john@example.com"
    expect(user_without_email.save).to eq(true)
  end
end
