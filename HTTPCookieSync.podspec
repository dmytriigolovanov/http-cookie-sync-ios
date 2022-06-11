Pod::Spec.new do |spec|
  spec.name             = 'HTTPCookieSync'
  spec.version          = '1.0.0'
  spec.summary          = 'Use HTTPCookieSync to synchronize cookies storages'
  spec.description      = <<-DESC
HTTPCookieSync is an iOS library that allows synchronizing cookies between HTTPCookieStorage and WebKit's WKHTTPCookieStore.
                       DESC

  spec.homepage         = 'https://github.com/dmytriigolovanov/http-cookie-sync-ios'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors          = 'Dmytrii Golovanov', 'Vladyslav Otsevyk', 'Serhii Reznichenko'
  spec.source           = { :git => 'https://github.com/dmytriigolovanov/http-cookie-sync-ios.git', :tag => spec.version.to_s }

  spec.ios.deployment_target = '11.0'

  spec.source_files = 'HTTPCookieSync/Sources/**/*'
  spec.public_header_files = 'HTTPCookieSync/Sources/Headers/**/*.h'
end