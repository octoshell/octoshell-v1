FactoryGirl.define do
  factory :credential do
    name "Key 1"
    user
    sequence(:public_key) { |n| "ssh-rsa AAAAB#{n}NzaC1yc2EAAAADAQABAAABAQDrA60pwY+uX2KKzEzkfOByfBy6l73MvEvn6UvJlFMgm+/3XnVN9QRSgJA4ICb/Scj14ed5XyT7pCpn6CD4NMWgXhDBuKDcKRJR1k15+PmjlqJa7ZtjfYAe7aPP6faKGSBH3xlQqOCM3JujMvLuGpl0p3MF2qrEI9nDHASthKPx+mqkFd8SUcuvAcQPBUAMjPaDu2FnWKHwhGz+m5Gl4B5TRQem8LSEq1P9X07Vp9V13uAdhlIoFS3+6yyiL7xWz0sedzSTshKzKs3KY9cGif+9lI8A5VClYv8IgAMf512RMxL3+QxF3chUER1HflPUHtkBMtPpm9GRwTk9UvNrnd91 user_#{n}@email.com" }
    before :create do |credential|
      credential.skip_creating_accesses = true
    end
  end
end
