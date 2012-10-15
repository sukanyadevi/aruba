Feature: Interactive process control

  In order to test interactive command line applications
  As a developer using Cucumber
  I want to use the interactive session steps

#The line with `sleep 3` is to avoid a bug in jruby (see http://jira.codehaus.org/browse/JRUBY-6942)
  Scenario: Running ruby interactively
    Given a file named "echo.rb" with:
      """
      while res = gets.chomp
        break if res == "quit"
        puts res.reverse
      end
      """
    When I run `ruby echo.rb` interactively
    And I run `sleep 3`
    And I type "hello, world"
    And I type "quit"
    Then it should pass with:
      """
      dlrow ,olleh
      """

  @posix
  Scenario: Running a native binary interactively
    When I run `cat` interactively
    And I type "Hello, world"
    And I type ""
    Then the output should contain:
      """
      Hello, world
      """

  @posix
  Scenario: Stop processes before checking for filesystem changes 
    See: http://github.com/aslakhellesoy/aruba/issues#issue/17 for context

    Given a directory named "rename_me"
    When I run `mv rename_me renamed` interactively
    Then a directory named "renamed" should exist
    And a directory named "rename_me" should not exist
