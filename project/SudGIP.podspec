Pod::Spec.new do |spec|
    spec.name              = 'SudGIP'
    spec.version           = '1.0.0'
    spec.license           = { :type => 'Copyright',:text => "Copyright © 2020-2024 SUD. All Rights Reserved.\n" }
    spec.homepage          = 'https://docs.sud.tech'
    spec.authors           = { 'sud.tech' => 'dev@sud.tech' }
    spec.summary           = 'The SudGIP SDK for iOS.'
    spec.description       = 'SudASR is a ASR SDK for iOS by SUD.'
    spec.documentation_url = 'https://docs.sud.tech'
    spec.platforms         = { 'ios':'11.0' }
    spec.source       = {:path => '.'}
    spec.requires_arc     = true
    spec.default_subspec = 'Stand'

    spec.subspec 'Base' do |ss|
      ss.vendored_frameworks = 'SudSDK/SudGIP.xcframework'
    end

    spec.subspec 'Stand' do |ss|

      ss.dependency "#{spec.name}/Base"
      
    end
  end


## 备注：
# 1. 本地依赖SDK时
# 屏蔽直接依赖 ss.dependency 'SudMGPxx', 'x.x.x.x'，放开
# ss.vendored_frameworks = [
#   'SudGIPSDK/SudGIP.xcframework'
# ]
#
# 2. 本地远程依赖SDK
# 屏蔽本地依赖SDK
# ss.vendored_frameworks = [
#   'SudGIPSDK/SudGIP.xcframework'
# ]
# 放开远程依赖：ss.dependency 'SudMGPxx', 'x.x.x.x'


