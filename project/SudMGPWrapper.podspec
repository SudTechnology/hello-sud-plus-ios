#
# Be sure to run `pod lib lint SudMGP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SudMGPWrapper'
  s.version          = '1.0.6'
  s.summary          = 'A short description of SudMGPWrapper.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/dingguanghui/SudMGP'
  s.license          = { :type => 'MIT', :file => 'SudMGPWrapper/LICENSE' }
  s.author           = { 'dingguanghui' => 'dingguanghui@divtoss.com' }
  s.source       = {:path => '.'}
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  #  s.static_framework = false
  
  s.ios.deployment_target = '11.0'
  s.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'tech.sud.SudMGPWrapper' }

  s.subspec 'SudMGPWrapper' do |ss|
      ss.ios.deployment_target = '11.0'
      ss.public_header_files = 'SudMGPWrapper/**/*.h'

      ss.source_files = [
        'SudMGPWrapper/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'SudMGPWrapper/Decorator/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'SudMGPWrapper/Model/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'SudMGPWrapper/State/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
      ]
      ss.vendored_frameworks = [
         'SudMGPSDK/SudMGP.xcframework'
      ]

      # json
      ss.dependency 'MJExtension', '~> 3.4.1'
      # 轻量版（不支持部分游戏，包体较小）
#      ss.dependency 'SudMGP_Lite', '1.3.5'
      # 标准版（支持全部游戏，包体会大一些）
#      ss.dependency 'SudMGP', '1.3.5'
    end
end

## 备注：
# 1. 本地依赖SDK时
# 屏蔽直接依赖 ss.dependency 'SudMGPxx', 'x.x.x.x'，放开
# ss.vendored_frameworks = [
#   'SudMGPSDK/SudMGP.xcframework'
# ]
#
# 2. 本地远程依赖SDK
# 屏蔽本地依赖SDK
# ss.vendored_frameworks = [
#   'SudMGPSDK/SudMGP.xcframework'
# ]
# 放开远程依赖：ss.dependency 'SudMGPxx', 'x.x.x.x'


