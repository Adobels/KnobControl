Pod::Spec.new do |s|
  s.name         = "KnobControl"
  s.version      = "0.0.1"
  s.summary      = "A knob control like the UISlider, but in a circular form."
  s.description  = "The knob control is a completely customizable widget that can be used in any iOS app. It also plays a little victory fanfare."
  s.homepage     = "https://github.com/Adobels/KnobControl"
  s.license      = "MIT"

  s.author    = "Adobels"

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/Adobels/KnobControl.git", :tag => "#{s.version}" }
  s.swift_version = "4.1"

  s.source_files  = "KnobControl"
end
