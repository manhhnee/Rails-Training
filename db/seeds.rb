# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  birthday = Faker::Date.birthday(min_age: 18, max_age: 100)
  gender = %w[male female other].sample
  password = "password"

  User.create!(
    name: name,
    email: email,
    birthday: birthday,
    gender: gender,
    password: password,
    password_confirmation: password,
    admin: true,
    activated: true,
    activated_at: Time.zone.now
  )
end
