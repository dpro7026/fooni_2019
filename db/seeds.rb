if Rails.env.development?
    AdminUser.create!(email: 'admin@example.com', password: 'admin1', password_confirmation: 'admin1')

    engsoc = User.create(username: 'EngSoc', name: 'Engineering Society', email: 'engsoc@mail.com', password: 'password', password_confirmation: 'password1', role: 'organisation', description: 'Engineering Society at the University of Sydney')

    event1 = Event.create(name: 'BBQ',
    	description: 'Let\'s celebrate the beginning of the semester with some free BBQ!',
    	member_price: 0.00,
    	non_member_price: 0.00,
    	location: 'Engineering Laws',
    	start_datetime: DateTime.new(2015,9,5,12,0),
    	end_datetime: DateTime.new(2015,9,5,13,0))
end
