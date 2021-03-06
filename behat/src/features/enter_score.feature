Feature: Enter a score for a player
    In order to get points in a tournament
    As a logged in user
    I want to enter scores

    # There are two ways to enter the score, using tournament id and player id
    # or by using the entry id directly

    Background:
        Given I am on "/login"
        When I fill in "id_inputUsername" with "charlie_murphy"
        When I fill in "id_inputPassword" with "darkness"
        When I press "Login"
        Then I should be on "/"

    Scenario: Logged in
        Given I am on "/enterscore/1"

    Scenario: Logged out
        Given I am on "/logout"
        Given I am on "/enterscore/1"
        Then I should be on "/login"

    Scenario Outline: I only know the tournament and username
        Given I am on "/enterscore/<tournament>/<username>"
        Then I should be on "<destination>"
        Then the response status code should be <code>
        Examples:
            |tournament         |username       |destination                    |code   |
            |painting_test      |rick_james     |/enterscore/1                  |200    |
            |                   |rick_james     |/enterscore//rick_james        |404    |
            |painting_test      |               |/enterscore/painting_test/     |404    |
            |foobar             |rick_james     |/enterscore/foobar/rick_james  |404    |
            |painting_test      |jimmy          |/enterscore/painting_test/jimmy|404    |

    Scenario Outline: URL malformed
        Given I am on "/enterscore/<id>"
        Then the response status code should be <code>
        Examples:
            | code | id |
            | 404  |    |
            | 400  | 0  |
            | 404  | a  |
            | 404  | 1a |
            | 200  | 1  |

    Scenario Outline: I enter some scores
        Given I am on "/enterscore/1"
        Then I fill in "id_key" with "number_tassles"
        Then I fill in "id_value" with "<score>"
        Then I press "Enter Score"
        Then the response status code should be 200
        Then I should see "<content>"
        Examples:
            |score | content                                    |
            | 1    | Invalid score: 1                           |
            | 29   | Invalid score: 29                          |
            | 5    | Score entered for rick_james: 5            |
            | 6    | 6 not entered. Score is already set        |

    Scenario Outline: The TO gives a painting score to a player
        When I POST "<value>" to "/entertournamentscore" from the API
        Then the API response should contain "<response_text>"
        Then the API response status code should be <response_code>

        Examples:
            |value                                                                                      |response_code  |response_text                          |
            |foo                                                                                        |400            |Enter the required fields              |
            |tournament=painting_test&key=fanciest_wig&value=20                                         |400            |Enter the required fields              |
            |username=stevemcqueen&key=fanciest_wig&value=20                                            |400            |Enter the required fields              |
            |username=stevemcqueen&username=stevemcqueen&key=fanciest_wig&value=20                      |400            |Enter the required fields              |
            |username=stevemcqueen&tournament=painting_test&value=20                                    |400            |Enter the required fields              |
            |username=stevemcqueen&tournament=painting_test&key=fanciest_wig                            |400            |Enter the required fields              |
            |username=stevemcqueen&tournament=painting_test&key=fanciest_wig&                           |400            |Enter the required fields              |
            |username=jimmynoname&tournament=painting_test&key=fanciest_wig&value=20                    |400            |Unknown player: jimmynoname            |
            |username=stevemcqueen&tournament=notatournament&key=fanciest_wig&value=20                  |400            |Unknown tournament: notatournament     |
            |username=rick_james&tournament=painting_test&key=fanciest_wig&value=ham                    |400            |Invalid score: ham                     |
            |username=rick_james&tournament=painting_test&key=magic&value=20                            |400            |Unknown category: magic                |
            |username=rick_james&tournament=painting_test&key=fanciest_wig&value=1000                   |400            |Invalid score: 1000                    |
            |username=rick_james&tournament=painting_test&key=fanciest_wig&value=-3                     |400            |Invalid score: -3                      |
            |username=rick_james&tournament=painting_test&key=fanciest_wig&value=14                     |200            |Score entered for rick_james: 14       |
            |username=rick_james&tournament=painting_test&key=fanciest_wig&value=12                     |400            |12 not entered. Score is already set   |
            |username=rick_james&username=rick_james&tournament=painting_test&key=fanciest_wig&value=9  |400            |9 not entered. Score is already set    |
            |username=rick_james&username=jerry&tournament=painting_test&key=fanciest_wig&value=8       |400            |8 not entered. Score is already set    |


    # TODO User controls
    Scenario: another player
    Scenario: to
