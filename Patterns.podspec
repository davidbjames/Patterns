
Pod::Spec.new do |spec|
  spec.name         = "Patterns"
  spec.version      = "0.1.0"
  spec.summary      = "Repository of design patterns using Swift protocols."
  spec.homepage     = "https://github.com/davidbjames/Patterns"
  spec.license         = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "David James" => "davidbjames1@gmail.com" }

  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/davidbjames/Patterns.git", :tag => "0.1.0" }
  spec.source_files = "Patterns/**/*.{swift}"
  spec.resources    = "Patterns/**/*.md"
  spec.exclude_files = "Patterns/**/*.{playground,plist,h}/**/*"

  spec.requires_arc = true
  # spec.ios.deployment_target = "9.0"
end
