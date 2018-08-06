# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Misonic' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks! 

    # Pods for Misonic
  
    pod 'Alamofire'
    pod 'AlamofireImage'
    pod 'RealmSwift'
    pod 'SwiftLint'
    pod 'Reusable'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
                
                if config.name == 'Release'
                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
                    config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
                    else
                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
                end
            end
        end
    end
end
