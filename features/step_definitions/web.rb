When /debug/ do
  @debugger ||= Fiber.new do
    n, path = 0, '/Users/releu/Desktop/'
    loop do
      n = n + 1
      page.driver.render("#{path}/screenshot_#{n}.png", full: true)
      Fiber.yield
    end
  end
  sleep 0.5
  @debugger.resume
  save_and_open_page
end

Given /^I am signed in as "(.*)"$/ do |user|
  user = FactoryGirl.create(:"#{user}_user")
  visit root_path
  within('.navbar') do
    click_on 'Sign In'
  end
  within('#new_user') do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456'
    click_on 'Sign In'
  end
  @current_user = user
end

Given /^I am on root page$/ do
  visit root_path
end

Given /^I click on "([^\"]+)"$/ do |name|
  if name =~ /^\.js-/
    find(name).click
  else
    click_on name
  end
end

Given /^I click on "([^\"]+)" the "([^\"]+)"$/ do |element, place|
  click = proc { click_on element }
  case place.to_sym
  when :request then
    within(".js-request-#{@request.id}", &click)
  when :group then
    within(".js-group-#{@group.id}", &click)
  end
end

When /^I fill in "(.*)" with "(.*)"$/ do |field, value|
  if field =~ /^\.js-/
    find(field).set value
  else
    fill_in field, with: value
  end
end

When /^I fill in "(.*)" with "(.*)" in "(.*)" member$/ do |field, value, num|
  num = num.to_i - 1
  name = "surety[surety_members_attributes][#{num}][#{field.downcase.gsub(' ', '_')}]"
  fill_in name, with: value
end

When /^I select "(.*)" from "(.*)"$/ do |value, field|
  select value, from: field
end

When /^I fill in input with class "(.*)" with "(.*)" in last membership form$/ do |klass, value|
  within(".members-form:last-child") do
    find("input.#{klass}").set(value)
    page.execute_script("$('input.#{klass}').blur()")
  end
end

When /^I should see "(.*)"$/ do |text|
  page.should have_content(text)
end

When /^I signed out$/ do
  step %(I click on "Sign Out")
end

When /^I confirm dialog$/ do
  page.evaluate_script("window.confirm()")
end

When /^I check ability for "(\w+)" "(\w+)"$/ do |action, subject|
  page.find(".js-ability-#{action}-#{subject}").set(true)
end

And /^the page should have link to "(.*)"$/ do |name|
  page.should have_link("Print Members List")
end
