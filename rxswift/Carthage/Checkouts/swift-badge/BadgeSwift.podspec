Pod::Spec.new do |s|
  s.name        = "BadgeSwift"
  s.version     = "8.0.0"
  s.license     = { :type => "MIT" }
  s.homepage    = "https://github.com/marketplacer/swift-badge"
  s.summary     = "Badge view for iOS and tvOS written in Swift"
  s.description  = <<-DESC
                   This is a UI widget for iOS that shows a badge.

                   * The badge is a subclass of UILabel view.
                   * It can be created and customized from the Storyboard or from the code.
                   DESC
  s.authors     = { "Evgenii Neumerzhitckii" => "sausageskin@gmail.com" }
  s.source      = { :git => "https://github.com/marketplacer/swift-badge.git", :tag => s.version }
  s.screenshots  = "https://raw.githubusercontent.com/marketplacer/swift-badge/master/graphics/swift_badge_showcase_2.png"
  s.source_files = "BadgeSwift/**/*.swift"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.swift_versions = ["4.2", "5.0"]
end