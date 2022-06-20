Pod::Spec.new do |spec|
  spec.name          = "InstantSearchTelemetry"
  spec.version       = "0.1.2"
  spec.summary       = "InstantSearch telemetry collection logic."
  spec.homepage      = "https://github.com/algolia/instantsearch-telemetry-native"
  spec.license       = { :type => 'Apache 2.0' }
  spec.author        = { "Algolia" => "contact@algolia.com" }
  spec.swift_version = "5.2"
  spec.platforms     = { :ios => "9.0", :osx => "10.11", :watchos => "3.0", :tvos => "9.0" }
  spec.source        = { :git => "https://github.com/algolia/instantsearch-telemetry-native", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/InstantSearchTelemetry/**/*.{swift}"
  spec.dependency 'SwiftProtobuf', '~> 1.19'
end
