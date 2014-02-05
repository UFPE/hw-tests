require 'open3'

<<<<<<< HEAD
Given /I have AutoGrader setup/ do
  cli_string = 'cucumber'
  ENV['BUNDLE_GEMFILE']='Gemfile'
  puts 'Running cucumber and rspec tests on RAG....'
  Dir.chdir('rag') do
    @test_output, @test_errors, @test_status = Open3.capture3(cli_string)
  end

  expect(@test_status).to be_success
end

Given(/^that I am in the project root directory "(.*?)"$/) do |project_dir|
=======
# GIVEN STEPS
#
#Given /I have AutoGrader setup/ do
#  Dir.chdir('rag') do
#    ENV['BUNDLE_GEMFILE']='Gemfile'
#    puts `bundle install --deployment`
#    puts `cucumber`
#  end
#end


Given(/^the AutoGrader is cloned and gems are installed$/) do
  expect(Dir).to exist("rag")
end

When /^I run cucumber for AutoGrader$/ do
  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, 'bundle exec cucumber' , :chdir => 'rag'
  )
end

Then(/^I should see that there are no errors$/) do
  expect(@test_status).to be_success
end

















Given /^that I am in the project root directory "(.*?)"$/ do |project_dir|
>>>>>>> 05c81ec... Added Runs the AutoGrader Scenario
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

Then(/^I should see a directory "(.*?)" with at least one file$/) do |dir_name|
  @homeworks.each do |hw|
    dir = "#{hw}/#{dir_name}"
    expect(Dir).to exist(dir)
    # requires at least one file with extension in subtree, allows empty folders
    dir_files = Dir[dir+'/**/*.*']
    expect(dir_files).not_to be_empty
  end
end

Given(/^I have a homework "(.*?)"$/) do |hw_name|
  expect(Dir).to exist("#{@hw}/#{hw_name}")
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
<<<<<<< HEAD
Then /^I run cucumber in "rag"$/ do
  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, 'bundle exec cucumber', :chdir => 'rag'
  )
end
=======
>>>>>>> 05c81ec... Added Runs the AutoGrader Scenario
