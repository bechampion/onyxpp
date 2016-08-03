###Some variables.
$projectname = hiera("project::name")
$projectpath = hiera("project::path")
$projectsource = hiera("project::source")


###I should figure out a way to do this for others too..
if $::lsbdistdescription == "Ubuntu 14.04.5 LTS" {
	package { "postgresql-server-dev-9.3": ensure => 'present' } 
} else { 
	fail ("This manifest is written for ubuntu 14.04")
}	
###Installing RVM
class { ::rvm: gnupg_key_id => false }
rvm_system_ruby {
  'ruby-2.3.0':
    ensure      => 'present',
    default_use => true,
}
### Specific gems.
rvm_gem {
  'bundler':
    name         => 'bundler',
    ruby_version => 'ruby-2.3.0',
    ensure       => latest,
    require      => Rvm_system_ruby['ruby-2.3.0'];
}

### Make sure git is installed
class { 'git': noops => false }

###Clone Repo
git::reposync{'onyx':
 destination_dir   => $projectpath,
 source_url => $projectsource
}

###Adding some files to the Gemfile this should be fixed somewhere else.
file_line { 'execjs': path => "${projectpath}/Gemfile" , line => "gem 'execjs'"}
file_line { 'rubyracer': path => "${projectpath}/Gemfile" , line => "gem 'therubyracer', :platforms => :ruby"}

###Exec bundle install
exec { 'bundleinstall': command => 'rvm 2.3.0 do bundle install' , cwd => $projectpath  , path => ['/usr/local/rvm/bin/','/bin/','/usr/bin','/sbin','/usr/sbin'] }

###Rails Server
exec { 'running rails': command => 'rvm 2.3.0 do rails server -d -b 0.0.0.0' , cwd => $projectpath , path =>  ['/usr/local/rvm/bin/','/bin/','/usr/bin','/sbin','/usr/sbin'] } 

###Main Class chain
Package['postgresql-server-dev-9.3'] -> 
Class['rvm'] -> 
Rvm_system_ruby['ruby-2.3.0'] -> 
Rvm_gem['bundler'] -> 
Class['git'] -> 
Git::Reposync['onyx'] -> 
File_line['execjs'] ->
File_line['rubyracer'] ->
Exec['bundleinstall'] ->
Exec['running rails']


