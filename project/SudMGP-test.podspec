Pod::Spec.new do |spec|
    spec.name              = 'TestSub'
    spec.version           = '1.3.8'
    spec.license           = { :type => 'Copyright',:text => "Copyright © 2020-2024 SUD. All Rights Reserved.\n" }
    spec.homepage          = 'https://docs.sud.tech'
    spec.authors           = { 'sud.tech' => 'dev@sud.tech' }
    spec.summary           = 'The SudMGP SDK for iOS.'
    spec.description       = 'SudMGP Game SDK for iOS by SUD.'
    spec.documentation_url = 'https://docs.sud.tech'
    spec.platforms         = { 'ios':'11.0' }
    spec.source            = { :http => 'https://test-1251277288.cos.ap-guangzhou.myqcloud.com/v1.0.0.zip' }
    # spec.source            = { :http => 'https://resource.sud.tech/developer/sdk/ios/SudMGP-iOS-1.3.8.1384-lite.zip', :sha1 => '719f60e14b63d3bcaf8956710043e1db15192eab' }
    spec.module_name       = 'TestSub'
    spec.ios.deployment_target = '11.0'
    # spec.pod_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]": "arm64" }
    # spec.user_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]": "arm64" }
    spec.requires_arc     = true
    # spec.vendored_frameworks = 'SudMGP.xcframework'
    spec.default_subspec = 'Stand'
    spec.subspec 'Wrapper' do |ss|
      ss.vendored_frameworks = 'Stand/SudMGP.xcframework'
      ss.public_header_files = 'SudMGPWrapper/**/*.h'
      ss.source_files = [
        'SudMGPWrapper/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'SudMGPWrapper/Decorator/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'SudMGPWrapper/Model/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'SudMGPWrapper/State/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
      ]
        # json
      ss.dependency 'MJExtension', '~> 3.4.1'
    end
    spec.subspec 'Stand' do |ss|
      ss.vendored_frameworks = 'Stand/SudMGP.xcframework'
      ss.dependency 'TestSub/Wrapper'
    end
    # spec.subspec 'Lite' do |ss|
    #   ss.vendored_frameworks = 'Stand/SudMGP.xcframework'
    #   ss.dependency 'TestSub/Wrapper'
    # end


  end
