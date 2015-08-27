

Pod::Spec.new do |spec|
  spec.name         = 'Patterns'
  spec.version      = '0.0.1'
  spec.license      = 'MIT'
  spec.summary      = 'Repository of various design patterns using protocols and some reusable implementation'
  spec.homepage     = 'https://bitbucket.org/davidbjames/patterns'
  spec.author       = 'David James'
  spec.source       = { :git => 'https://bitbucket.org/davidbjames/patterns' }
  spec.source_files = 'Patterns/**/*.swift'
  spec.requires_arc = true
  spec.platform     = :ios, '9.0'
  spec.ios.deployment_target = '8.0'
  spec.dependency 'Mantle', '2.0.4' # Generalized dependency for model objects
end
