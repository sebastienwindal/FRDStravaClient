#
#  Be sure to run `pod spec lint FRDStravaClient.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  
  s.name         = "FRDStravaClient"
  s.version      = "1.0.0"
  s.summary      = "A iOS Strava API client."
  s.description  = <<-DESC
                   A iOS client for the Strava API written in obj-C,
                   leverages AFNetworking for networking operations and Mantle for
                   JSON conversion to usable objects.
                   DESC
  s.homepage     = "http://github.com/sebastienwindal/FRDStravaClient"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author    = "Sebastien Windal"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/sebastienwindal/FRDStravaClient.git", :tag => "1.0.0" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 2.0"
  s.dependency "Mantle", "1.5"

end
