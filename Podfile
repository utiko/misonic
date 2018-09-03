# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

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
      installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
      end
    end
end
