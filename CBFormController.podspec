#
# Be sure to run `pod lib lint CBFormController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CBFormController"
  s.version          = "0.3.16"
  s.summary          = "A customizable iOS Form Controller."
  s.homepage         = "https://github.com/cameronbell/CBFormController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Cameron Bell" => "cameron.bell@me.com" }
  s.source           = { :git => "https://github.com/cameronbell/CBFormController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'CBFormController/Classes/**/*.{h,m}'
  s.resources = 'CBFormController/Classes/**/*.{xib,ttf,otf}'
#s.resource_bundles = {
#   'CBFormController' => ['Pod/Assets/*.png']
# }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreText'
  s.dependency 'FontAwesome', '~> 4.3.0'
  s.dependency 'UITextView+Placeholder'
  s.dependency 'MZFormSheetController', '~> 3.1'
  s.dependency 'MLPAutoCompleteTextField', '1.5'
end
