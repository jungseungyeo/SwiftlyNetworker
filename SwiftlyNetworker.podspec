#
# Be sure to run `pod lib lint SwiftlyNetworker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftlyNetworker'
  s.version          = '0.1.1'
  s.summary          = 'A short description of SwiftlyNetworker.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jungseungyeo/SwiftlyNetworker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jungseungyeo' => 'duwjdtmd91@gmail.com' }
  s.source           = { :git => 'https://github.com/jungseungyeo/SwiftlyNetworker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.source_files = 'SwiftlyNetworker/Classes/**/*'
end
