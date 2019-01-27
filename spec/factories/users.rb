FactoryBot.define do
  factory :user do
    username { 'John Soc' }
    email { 'john@example.com' }
    password { 'password' }
    name { 'John\'s Society' }
    role { 'organisation' }
    description { 'Hi I\'m John and I like to Party!' }
  end

  factory :user_without_email, class: User do
    username { 'John Soc' }

    password { 'password' }
    name { 'John\'s Society' }
    role { 'organisation' }
    description { 'Hi I\'m John and I like to Party!' }
  end

  factory :random_user, class: User do
    username { Faker::Pokemon.name }
    email { Faker::Internet.safe_email }
    password { 'password' }
    name { Faker::FunnyName.two_word_name }
    role { 'organisation' }
    description { Faker::Lorem.sentence(3) }
  end
end
