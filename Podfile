# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'RxSwiftDemo' do
use_frameworks!


# Swift版本
pod 'RxSwift', '~> 5.0'
pod 'RxCocoa', '~> 5.0'

# OC版本
pod 'ReactiveObjC'


end


# 实现post_install Hooks
post_install do |installer|
  # 1. 遍历项目中所有target
  installer.pods_project.targets.each do |target|
    # 2. 遍历build_configurations
    target.build_configurations.each do |config|
      # 3. 修改build_settings中的ENABLE_BITCODE
      config.build_settings['ENABLE_BITCODE'] = 'NO'
#      config.build_settings['ARCHS'] = 'arm64'
    end
  end
end


