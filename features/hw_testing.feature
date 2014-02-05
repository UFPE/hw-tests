Feature: Testing instructor created homeworks
  In order to check that the supplied homework can be graded by AutoGrader
  As a AutoGrader maintainer
  I would like these homeworks to be automatically tested on submit

  Scenario: The project is cloned from AV/rag repo and installed
    Given the AutoGrader is cloned and gems are installed
    When I run cucumber for AutoGrader
    Then I should see that there are no errors

  Scenario: Runs the AutoGrader on the homework
    Given I have the homework in "hw/ruby-intro"
    When I run AutoGrader with the following spec sheet:
      | test_subject           | spec                     |
      | solutions/lib/part1.rb | autograder/part1_spec.rb |
    Then I should see that there are no errors
    And I should see the execution results

  Scenario:
    Given I have the homework in "hw/ruby-intro"
    When I run AutoGrader with the following spec sheet:
      | test_subject           | spec                     | expected_result |
      | solutions/lib/part1.rb | autograder/part1_spec.rb | 100:100         |
    Then I should see the expected result
    And I should see the execution results
