sudo apt-get install puppet &&
sudo gem install librarian-puppet &&
cd /vagrant/puppet/
sudo librarian-puppet install 
sudo curl -sSL https://rvm.io/mpapis.asc | gpg --import -
#puppet apply manifests/ --modulepath=modules/ --hiera_config=hiera.yaml 

