# Rake-задача для заполнения Б.Д. образцами пользователей, испльзуя gem 'faker'
# p_379: этот код дублирует существ. пользователя, а затем создает 99 образцов.
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             # p_405: активация образцов пользователей по умолч.
             activated: true,
             # p_405: м. Time.zone.now - возвр. тек. отметку времени с уч. пояса
             activated_at: Time.zone.now)
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  # метод create! - действует также, как create, только вызывает искл.
    # для недопустимого пользователя, вместо возврата false
  User.create!(name: name,
               email: email,
               password:               password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# p_380:
# в консоли:
# 1). После добавления gem 'faker'
# $ bundle install
#
# 2). Чтобы выполнить Rake-задачу, нужно сначала очистить Б.Д., а потом вызвать:
# $ rails db:migrate:reset
# $ rails db:seed