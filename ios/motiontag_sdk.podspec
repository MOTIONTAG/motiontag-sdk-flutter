#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint motiontag.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'motiontag_sdk'
  s.version          = '1.0.0'
  s.summary          = 'Flutter wrapper for the MOTIONTAG SDK'
  s.description      = 'Flutter wrapper for the MOTIONTAG SDK'
  s.homepage         = 'https://github.com/MOTIONTAG/motiontag-sdk-flutter#readme'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MOTIONTAG GmbH' => 'info@motion-tag.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.3'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.dependency 'MotionTagSDK', '5.2.0'
end
