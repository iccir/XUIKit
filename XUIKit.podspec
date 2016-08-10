Pod::Spec.new do |s|
  s.name         = "XUIKit"
  s.version      = "1.0.0"
  s.summary      = "XUIKit uses categories to make NSBezierPath, NSColor, NSFont completely API compatible with their UIKit counterparts."

  s.description  = <<-DESC
                   XUIKit uses categories to make NSBezierPath, NSColor, NSFont completely API compatible with their UIKit counterparts.
                   DESC

  s.homepage     = "https://github.com/iccir/XUIKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ricci Adams" => "leonard@hecker.io" }

  s.platform     = :osx
  s.source       = { :git => "https://github.com/iccir/XUIKit.git", :tag => "1.0.0" }

  s.source_files  = "Source/*.{h,m}"
  s.public_header_files = "Source/*.h"

  s.requires_arc = true
end
