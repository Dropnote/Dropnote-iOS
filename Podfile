source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!

target :Brewer do
    pod 'Swinject', '2.0.0-beta.2'
    pod 'SwinjectStoryboard', '1.0.0-beta.2'

    pod 'RxSwift', '~> 3.0.0-beta.1'
    pod 'RxCocoa', '~> 3.0.0-beta.1'

    pod 'ObjectMapper'
    pod 'XCGLogger', '~> 4.0.0'
    pod 'FormatterKit'
    pod 'DZNEmptyDataSet'

    pod 'Google/Analytics'
    pod 'Fabric'
    pod 'Crashlytics'
    
    target :BrewerTests do
        
        pod 'Quick'
        pod 'Nimble', '~> 5.0.0'
        pod 'RxTests', '~> 3.0.0-beta.1'
        pod 'RxBlocking', '~> 3.0.0-beta.1'
    end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end