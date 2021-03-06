Feature: Front page of the website
  In order to use TO from the internet
  As a website user
  I need to be able to visit the font page

  Scenario: I visit the front page
    Given I am on "/"
    Then I should see "Basic behaviour"

  Scenario: Hit the API
    When I GET "/" from the API
    Then the response status code should be 200
