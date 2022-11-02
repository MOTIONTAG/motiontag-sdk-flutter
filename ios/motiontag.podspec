#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint motiontag.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'motiontag'
  s.version          = '1.0.0'
  s.summary          = 'Flutter wrapper for the MOTIONTAG SDK'
  s.description      = <<-DESC
Flutter wrapper for the MotionTag SDK
                       DESC
  s.homepage         = 'https://github.com/MOTIONTAG/motiontag-sdk-flutter#readme'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MOTIONTAG GmbH' => 'info@motion-tag.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.dependency 'MotionTagSDK', '4.2.1'
end
