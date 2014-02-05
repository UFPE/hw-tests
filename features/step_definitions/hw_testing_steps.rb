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
  cli_string = "./grade #{subject} #{spec}"
  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, cli_string, :chdir => 'rag'
  )
end

Given(/^the AutoGrader is cloned and gems are installed$/) do
  expect(Dir).to exist("rag")
end

When /^I run cucumber for AutoGrader$/ do
  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, 'bundle exec cucumber', :chdir => 'rag'
  )
end

Then(/^I should see that there are no errors$/) do
  expect(@test_status).to be_success
end


Given /I run AutoGrader with the following spec sheet:/ do |table|
  table.hashes.each do |hash|
    test_subject_path = "../#{@hw_path}/#{hash[:test_subject]}"
    spec_path = "../#{@hw_path}/#{hash[:spec]}"
    run_ag(test_subject_path, spec_path)
  end
end

Given /I have the homework in "([^"]*)"/ do |path|
  @hw_path = path
end

Then /I should see the execution results/ do
  puts @test_status
  puts @test_errors
  puts @test_output
end






Given /^that I am in the project root directory "(.*?)"$/ do |project_dir|
  @project_dir = project_dir
  expect(File.basename(Dir.getwd)).to eq @project_dir
end

And(/^that there is an autograders directory "(.*?)"$/) do |rag|
  @rag = rag
end

And(/^that there is a homeworks directory "(.*?)"$/) do |hw|
  @hw = hw
end

When(/^I check the autograders directory$/) do
  expect(Dir).to exist(@rag)
end

When(/^I delete all the autograder log files$/) do
  dir_path = Dir.getwd+"/#{@rag}/log"
  FileUtils.rm_rf("#{dir_path}/.", secure: true)
  autograder_logs = "#{@rag}/log/*"
  expect(Dir[autograder_logs]).to be_empty
end

When(/^I check each homeworks directory$/) do
  expect(Dir).to exist(@hw)
  @homeworks = Dir.glob("#{@hw}/*").select { |f| File.directory? f }
end

When(/^I run the AutoGrader on this homework$/) do
  # AutoGraders must be run from the rag directory because of relative requires
  rag_to_hw_path = '../hw'
  test_subject_path = "#{rag_to_hw_path}/ruby-intro/solutions/lib/part1.rb"
  spec_path = "#{rag_to_hw_path}/ruby-intro/autograder/part1_spec.rb"

  cli_string = "./grade #{test_subject_path} #{spec_path}"
  ENV['BUNDLE_GEMFILE']='Gemfile'

  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, cli_string, :chdir => 'rag'
  )

  puts @test_output

end

Then(/^I should see an autograder directory "([^"]*)"/) do |dir_name|
  expect(Dir).to exist(@rag+'/'+dir_name)
end

Then(/^I should see no runtime errors$/) do
  expect(@test_errors).to eq ''
end

And(/^I should see that the process succeeded$/) do
  expect(@test_status).to be_success
end
And(/^I run cucumber in "rag"$/) do
  Dir.chdir('rag') do
    `cucumber`
  end
end
