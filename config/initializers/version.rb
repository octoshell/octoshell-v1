module MSU
  VERSION = (`git describe --always`.strip rescue nil) || 'undefined'
end
