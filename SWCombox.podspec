Pod::Spec.new do |s|

  s.name         = "SWCombox"
  s.version      = "2.3"
  s.summary      = "Simple Combo Box"
  s.description  = "Simple Combo Box - text / image & text"
  s.homepage     = "https://github.com/sw0906/SWCombox.git"
  s.screenshots  = "https://github.com/sw0906/SWCombox/blob/master/sample02.png"
  
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Shou Wei" => "sw0906@gmail.com" }
  s.source       = { :git => "https://github.com/sw0906/SWCombox.git", :tag => s.version }
  s.source_files  = "SWComboxLib/*"
end
