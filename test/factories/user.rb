Factory.sequence :username do |n|
  "user_#{n}-#{rand(9999)}"
end
Factory.sequence :email do |n|
  "user#{n}-#{rand(9999)}@example.com"
end

Factory.define :user do |f|
  f.login { Factory.next(:username) }
  f.email { Factory.next(:email) }
  f.password "password"
  f.password_confirmation "password"
  f.invite_not_needed true
end
