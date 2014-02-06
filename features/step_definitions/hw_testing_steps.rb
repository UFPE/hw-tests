require 'open3'

Given /I have AutoGrader setup/ do
  cli_string = 'cucumber'
  ENV['BUNDLE_GEMFILE']='Gemfile'
  puts 'Running cucumber and rspec tests on RAG....'
  Dir.chdir('rag') do
    @test_output, @test_errors, @test_status = Open3.capture3(cli_string)
  end

  expect(@test_status).to be_success
end

def run_ag(subject, spec)
  cli_string = "./grade ../#{subject} ../#{spec}"
  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, cli_string, :chdir => 'rag'
  )
end

## Given steps

Given(/^the AutoGrader is cloned and gems are installed$/) do
  expect(Dir).to exist('rag')
end

Given /I have the homework in "([^"]*)"/ do |path|
  @hw_path = path
end

## When steps

When /^I run cucumber for AutoGrader$/ do
  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, 'bundle exec cucumber', :chdir => 'rag'
  )
end

When(/^I run AutoGrader for (.*) and (.*)$/) do |test_subject, spec|
  run_ag("#{@hw_path}/#{test_subject}", "#{@hw_path}/#{spec}")
end

## Then steps

Then(/^I should see that the results are (.*)$/) do |expected_result|
  expect(@test_output).to match /#{expected_result}/
end

And(/^I should see the execution results with (.*)$/) do |test_title|
  success = @test_status.success? ? 'success' : 'failure'
  puts test_title + ': ' + success
  expect(success).to eq 'success'
end

Then(/^I should see that there are no errors$/) do
  expect(@test_status).to be_success
end

Then(/I should see the execution results$/) do
  puts @test_status
  puts @test_errors
  puts @test_output
end
