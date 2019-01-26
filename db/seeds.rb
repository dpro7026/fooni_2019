if Rails.env.development?
    AdminUser.create!(email: 'admin@example.com', password: 'admin1', password_confirmation: 'admin1')
end
