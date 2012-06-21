require 'aruba/api'

World(Aruba::Api)
World(Berkshelf::RSpec::FileSystemMatchers)

Then /^I trace$/ do
end

When /^I sleep$/ do
  sleep 10
end

Then /^a file named "(.*?)" should exist in the current directory$/ do |filename|
  in_current_dir do
    File.exists?(filename).should be_true # not sure why Aruba's
                                          # #check_file_presence
                                          # doesn't work here. It
                                          # looks in the wrong
                                          # directory.
  end
end

Then /^the file "(.*?)" should contain in the current directory:$/ do |filename, string|
  in_current_dir do
    File.read(filename).should match(Regexp.new(string))
  end
end

When /^I run the init command with the cookbook "(.*?)" as the target$/ do |cookbook_name|
  run_simple(unescape("knife berks init #{cookbook_name}"), false)
end

When /^I run the init command with the directory "(.*?)" as the target$/ do |directory_name|
  run_simple(unescape("knife berks init #{directory_name}"), false)
end

When /^I run the init command with no value for the target$/ do
  run_simple(unescape("knife berks init"), false)
end

When /^I run the install command$/ do
  run_simple(unescape("knife berks install"), false)
end

When /^I run the update command$/ do
  run_simple(unescape("knife berks update"), false)
end

When /^I run the upload command$/ do
  run_simple(unescape("knife berks upload"), false)
end

Then /^the CLI should exit with the status code for error "(.*?)"$/ do |error_constant|
  exit_status = Berkshelf.const_get(error_constant).status_code
  assert_exit_status(exit_status)
end