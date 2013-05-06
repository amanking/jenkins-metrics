Gem::Specification.new do |s|
  s.name = 'jenkins_client'
  s.version = '0.0.1'
  s.date = '2013-05-06'
  s.summary = 'Client to fetch commit/coverage info from Jenkins'
  s.authors = ['Kaizer Poonawala', 'Arjun Khandelwal', 'Tushar Madhukar']
  s.files = %x{git ls-files}.split("\n") - %w[.gitignore Rakefile]
  s.test_files = s.files.select {|p| p =~ /^spec\/.*.rb/ }

  s.add_dependency 'json', '>= 1.7.5'
end