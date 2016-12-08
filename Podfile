# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Wordie' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'AFNetworking', '~> 2.6'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'MBProgressHUD'
  pod 'Firebase/Storage'
  pod 'NVActivityIndicatorView'
  pod 'MarqueeLabel/Swift'


# Pods for FB
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

  # Pods for Wordie

end
