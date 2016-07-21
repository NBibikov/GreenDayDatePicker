#
# Be sure to run `pod lib lint GreenDayDatePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'GreenDayDatePicker'
s.version          = '0.1.2'
s.summary          = 'Simple date picker "GreenDayDatePicker" for iOS written on Objective-C. Work in two modes with only few lines of code!'

# This description is used to generate tags and improve search results.
# * Hello! My goal was create simple and not ugly date picker. It work in two mode - show in centre and of bottom screnn.
# * DatePicker will hidden after click outside or when user click button "Save".

s.description      = <<-DESC
Hello! My goal was create simple and not ugly date picker. It work in two mode - show in centre and of bottom screnn.

DatePicker will hidden after click outside or when user click button "Save".
DESC

s.homepage         = 'https://github.com/NBibikov/GreenDayDatePicker'
# s.screenshots     = 'https://raw.githubusercontent.com/NBibikov/GreenDayDatePicker/master/ScreenCasts/screenCast1.gif', 'https://raw.githubusercontent.com/NBibikov/GreenDayDatePicker/master/ScreenCasts/screenCast2.gif'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Nick Bibikov' => 'n.bibikov@me.com' }
s.source           = { :git => 'https://github.com/NBibikov/GreenDayDatePicker.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/nbibikov'

s.ios.deployment_target = '8.0'

s.source_files = 'GreenDayDatePicker/Classes/**/*'

# s.resource_bundles = {
#   'GreenDayDatePicker' => ['GreenDayDatePicker/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit'

end
