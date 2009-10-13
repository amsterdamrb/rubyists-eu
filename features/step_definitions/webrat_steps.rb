When /^I view the home page$/ do
  get '/'
end

When /^I click "([^\"]*)"$/ do |link|
  click_link link
end

When /^I click the button "([^\"]*)"$/ do |name|
  click_button name
end

When /^I enter "([^\"]*)" as "([^\"]*)"$/ do |value, field|
  fill_in field, :with => value
end

Then /^I should see "([^\"]*)"$/ do |text|
  last_response.should contain(text)
end