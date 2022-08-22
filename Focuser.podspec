Pod::Spec.new do |s|
  s.name             = 'Focuser'
  s.version          = '0.2.0'
  s.summary          = 'Focuser allows to focus SwiftUI text fields dynamically for iOS 13 and iOS 14.'

  s.homepage         = 'https://github.com/art-technologies/swift-focuser'
  s.author           = { 'art-technologies' => 'augustinas.malinauskas@arttechnologies.co' }
  s.source           = { :git => 'https://github.com/art-technologies/swift-focuser.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/Focuser/**/*'
end
