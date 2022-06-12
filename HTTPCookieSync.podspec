Pod::Spec.new do |s|
  s.name             = 'HTTPCookieSync'
  s.version          = '1.1.0'
  s.summary          = 'Use HTTPCookieSync to sync cookies storages'

  s.description      = <<-DESC
HTTPCookieSync is an iOS library that allows synchronizing cookies between HTTPCookieStorage and WebKit's WKHTTPCookieStore.
                       DESC

  s.homepage         = 'https://github.com/dmytriigolovanov/http-cookie-sync-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = 'Dmytrii Golovanov', 'Vladyslav Otsevyk', 'Serhii Reznichenko'

  s.source           = {
    :git => 'https://github.com/dmytriigolovanov/http-cookie-sync-ios.git',
    :tag => 'v' + s.version.to_s
  }

  s.preserve_paths = [
    "README.md",
    "CHANGELOG.md"
  ]

  s.ios.deployment_target = '11.0'

  s.swift_version = '5.0'

  s.source_files  = 'HTTPCookieSync/Sources/**/*'
  s.public_header_files = 'HTTPCookieSync/Sources/Headers/**/*.h'
end
