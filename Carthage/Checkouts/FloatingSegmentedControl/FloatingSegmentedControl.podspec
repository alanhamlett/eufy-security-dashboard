Pod::Spec.new do |s|
  s.name             = 'FloatingSegmentedControl'
  s.version          = "1.0.0"
  s.license          = { :type => "MIT", :file => "LICENSE" }

  s.summary          = "Segmented control like iOS13 photo app"
  s.homepage         = "https://github.com/catelina777/FloatingSegmentedControl"
  s.author           = 'catelina777'
  s.source           = { :git => "https://github.com/catelina777/FloatingSegmentedControl", :tag => s.version }
  s.social_media_url = 'https://twitter.com/catelina777'

  s.ios.deployment_target = "13.0"
  s.source_files = 'Source/**/*'
  s.frameworks = 'UIKit'
  s.swift_versions = ['5.0']
end

