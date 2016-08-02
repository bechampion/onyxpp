gem install puppet &&
gem install librarian-puppet &&
librarian-puppet install &&
puppet apply manifests/ --modulepath=modules/ --hiera_config=hiera.yaml 

