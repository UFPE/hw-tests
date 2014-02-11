Feature: Testing instructor created homeworks
  In order to check that the supplied homework can be graded by AutoGrader
  As a AutoGrader maintainer
  I would like these homeworks to be automatically tested on submit

  Scenario: The project is cloned from AV/rag repo and installed
    Given the AutoGrader is cloned and gems are installed
    When I run cucumber for AutoGrader
    Then I should see that there are no errors

  Scenario Outline: Runs AutoGrader with a given spec sheet
    Given I have the homework in "ruby-intro"
    When I run AutoGrader for <test_subject> and <spec>
    Then I should see that the results are <expected_result>
    And I should see the execution results with <test_title>
  Examples:
  | test_title                | test_subject           | spec                     | expected_result       |
  | Part1: specs vs solution  | solutions/lib/part1.rb | autograder/part1_spec.rb | Score out of 100: 100 |
  | Part1: specs vs skeleton  | public/lib/part1.rb    | autograder/part1_spec.rb | Score out of 100: 5   |
  | Part2: specs vs solution  | solutions/lib/part1.rb | autograder/part2_spec.rb | Score out of 100: 0   |
  | Part2: specs vs skeleton  | public/lib/part2.rb    | autograder/part2_spec.rb | Score out of 100: 30  |
  | Part3: specs vs solution  | solutions/lib/part1.rb | autograder/part3_spec.rb | Score out of 100: 0   |
  | Part3: specs vs skeleton  | public/lib/part3.rb    | autograder/part3_spec.rb | Score out of 100: 30  |
