Pod::Spec.new do |spec|
    spec.name              = 'SudASR'
    spec.version           = '1.0.0'
    spec.license           = { :type => 'Copyright',:text => "Copyright © 2020-2024 SUD. All Rights Reserved.\n" }
    spec.homepage          = 'https://docs.sud.tech'
    spec.authors           = { 'sud.tech' => 'dev@sud.tech' }
    spec.summary           = 'The SudASR SDK for iOS.'
    spec.description       = 'SudASR is a ASR SDK for iOS by SUD.'
    spec.documentation_url = 'https://docs.sud.tech'
    spec.platforms         = { 'ios':'11.0' }
    spec.source       = {:path => '.'}
    spec.requires_arc     = true
    spec.default_subspec = 'Stand'

    spec.subspec 'Base' do |ss|
      ss.vendored_frameworks = 'SudSDK/SudASR.xcframework'
    end

    spec.subspec 'Stand' do |ss|

      ss.dependency "#{spec.name}/Base"
      # support speech
      ss.dependency 'MicrosoftCognitiveServicesSpeech-iOS', '1.40.0'
    end
  end
