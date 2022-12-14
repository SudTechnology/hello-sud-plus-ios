#
# Be sure to run `pod lib lint SudMGPWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SudMGPWrapper'
  s.version          = '1.5.6'
  s.summary          = 'This is a Wrapper for SudMGP SDK'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = 'This is a Wrapper for SudMGP SDK, To enable developers to quickly access the SudMGP SDK'

  s.homepage         = 'https://github.com/SudTechnology/hello-sud-plus-ios'
  s.license          = { :type => 'MIT', :file => 'project/SudMGPWrapper/LICENSE' }
  s.authors          = { 'sud.tech' => 'dev@sud.tech' }
  s.source       = { :git => 'https://github.com/SudTechnology/hello-sud-plus-ios.git', :tag => "#{s.version}" }
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true

  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64'}
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }

  s.public_header_files = 'project/SudMGPWrapper/**/*.h'

  s.source_files = [
    'project/SudMGPWrapper/*.{h,m,mm,cpp,c,hpp,cc,swift}',
    'project/SudMGPWrapper/Decorator/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
    'project/SudMGPWrapper/Model/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
    'project/SudMGPWrapper/State/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
  ]
  s.dependency 'SudMGP', '~> 1.2.5.1'
  # json
  s.dependency 'MJExtension', '~> 3.4.1'
end
