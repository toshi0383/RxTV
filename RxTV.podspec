Pod::Spec.new do |s|
  s.name             = 'RxTV'
  s.version          = '0.2.1'
  s.summary          = 'Reactive Extension Pack for tvOS 📺'
  s.description      = <<-DESC
        'Reactive Extension Pack for tvOS 📺'
                       DESC
  s.homepage         = 'https://github.com/toshi0383/RxTV'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'toshi0383' => 't.suzuki326@gmail.com' }
  s.source           = { :git => 'https://github.com/toshi0383/RxTV.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/toshi0383'

  s.tvos.deployment_target = '9.0'

  s.source_files = 'RxTV/*.swift'
  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'


end
