Feature: Add a group
  As a member of Amsterdam.rb
  I want to add Amsterdam.rb to Rubyists.eu
  So That I can draw more attention to Amsterdam.rb

Scenario: Add Amsterdam.rb
  Given there are no groups
  When I view the home page
  And I click "add group"
  And I enter "Amsterdam.rb" as "name"
  And I enter "Amsterdam" as "city"
  And I enter "Netherlands" as "country"
  And I click "add group"
  Then I should see "1 group"
  And I should see "added Amsterdam.rb"
