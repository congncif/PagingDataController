#
# Be sure to run `pod lib lint PagingDataController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PagingDataController'
  s.version          = '1.1.3'
  s.summary          = 'A Swift pattern to apply paging data to UIViewController'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Only configure some properties & your view controller will load data by page automatically.
Magic !!!
                       DESC

  s.homepage         = 'https://github.com/congncif/PagingDataController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NGUYEN CHI CONG' => 'congnc.if@gmail.com' }
  s.source           = { :git => 'https://github.com/congncif/PagingDataController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/congncif'

  s.ios.deployment_target = '8.0'

#s.source_files = 'PagingDataController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PagingDataController' => ['PagingDataController/Assets/*.png']
  # }

s.vendored_frameworks = 'PagingDataController/PagingDataController.framework'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  #s.dependency 'SVPullToRefresh'
end
