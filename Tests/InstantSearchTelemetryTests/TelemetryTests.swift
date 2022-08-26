import XCTest
@testable import InstantSearchTelemetry

extension TelemetrySchema {
  
  /// Generates a random TelemetrySchema object
  static func random() -> Self {
    TelemetrySchema.with {
      $0.components = Array(TelemetryComponentType.allCases.map { type in
        TelemetryComponent.with { w in
          w.type = type
          w.isConnector = Bool.random()
          w.isDeclarative = Bool.random()
          w.parameters = Array(TelemetryComponentParams.allCases.shuffled().prefix((1..<10).randomElement()!))
        }
      }
        .shuffled()
        .prefix((1..<10).randomElement()!))
    }
  }
  
}

final class TelemetryTests: XCTestCase {
  
  func testEncodeDecode() throws {
    let schema = TelemetrySchema.with {
      $0.components = TelemetryComponentType.allCases.map { type in
        TelemetryComponent.with { w in
          w.type = type
          w.isConnector = true
          w.parameters = Array(TelemetryComponentParams.allCases.shuffled()[..<5])
        }
      }
    }
    let data = try schema.serializedData()
    let compressedData = data.gzipped()
    let uncompressedData = try compressedData.gunzipped()
    let decodedSchema = try TelemetrySchema(serializedData: uncompressedData)
    XCTAssertEqual(schema, decodedSchema)
  }
  
  func testOptOut() throws {
    let telemetry = InstantSearchTelemetry.shared
    
    telemetry.isEnabled = true
    telemetry.trace(type: .facetSearcher, parameters: .appID, .apiKey)
    XCTAssertTrue(telemetry.components.keys.contains(.facetSearcher))
    
    telemetry.reset()
    telemetry.isEnabled = false
    telemetry.trace(type: .facetList, parameters: .facets)
    XCTAssertTrue(telemetry.components.isEmpty)
  }
  
  func testStringDecoding() throws {
    // After each schema change, a list of encoded telemetry payloads might be added to this map
    // to test potential decoding regressions
    let versionedStrings = [
      "0.1.2": [
        "H4sIAAAAAAAAE3ukLXRAlfEECDGdUGU7oap1QZXxkTbbAVXWC6oMj7Q5D6hynFDVBgsC2YJICoTBCoAMEaAIABhKRiRIAAAA",
        "H4sIAAAAAAAAAHukzXZAlfGCKsMjEEMExmCFMTguqDICAIzMnTMkAAAA",
        "H4sIAAAAAAAAAHukzXZAlfGCKsMjEEMExhC+oMoIAGuHg1AbAAAA",
        "H4sIAAAAAAAAE3ukzXZAlfmCKgMAAAIDWgkAAAA=",
        "H4sIAAAAAAAAE3ukzXNAVfCEKt8JVZkLqgyPtNkOqIpcUGUEAJ/elTUYAAAA",
        "H4sIAAAAAAAAE3ukzX9AlfEECDGdUGW7oMrwSJvtgCormMFzQJXjhCr7CVUJmLggjCECZAAAlZEs0zwAAAA=",
        "H4sIAAAAAAAAAHukzXZAlfWCKsMjEIMRzOA8oMpxQlXigiojAP1WSJgeAAAA",
        "H4sIAAAAAAAAE3ukzXZAlfWCKgMA3F1ofwkAAAA=",
        "H4sIAAAAAAAAE3ukzX9AlfEECDGdUGW7oMrwSJvtgCormMFzQJXthCrnCVXJC6qMj7Q5D6hynFDVBrOBajhhigVhDCGYlDCMIQJkAADFQJdBYwAAAA==",
        "H4sIAAAAAAAAAHukzXZAlfGCKsMjEEMExhC+oMoIZrCCRTgPqHKcUJUACgIAjBiI0jAAAAA=",
      ],
      "0.1.3": [
        "H4sIAAAAAAAAE3ukzXlAleOCKuMNVcZH2mwHVDkvgBhAQWmYIJDNckGV4YYqA5jNBGEDAGxxFME5AAAA",
        "H4sIAAAAAAAAE02PuQ6DMBAFIaeUA5RDhNxCYiCR8/+1y1dSpuZLYi9CSmet582+7V3l2YpSFKIVU3EUM7EUr47kS9pHJhVz8RQr4UQu3orBmzFJ764+ps7iY1gQJqLuSO039+xtRTNOAr8zVSUy4y8hPtpKH+PtsEIcQp+/MplNCiszUTSvzXMfmdqzEQs7JDwe5jlZKkSyAfsBrWPsTvwAAAA=",
        "H4sIAAAAAAAAE03Muw6CQAAFUSFigxF8EE2IFsDEx/5/v+WUlNT7JSqGxHZyz02hjWylkYOcBRmkGMkmshSaSC6dXOUk67/+2beykZ3kc1+lMESOcpFe7lLKU+r5+SavhVfxa/fy+ME3DQXcuocAAAA=",
        "H4sIAAAAAAAAEz4n2rgbAAAA",
        "H4sIAAAAAAAAE2m9uRgqAAAA",
        "H4sIAAAAAAAAEzWNuwrCQADAroIOiqj1VRXFikHk/P/5xowdO/dLvJ64hpAM8ZlYyUFecpSLbOQjb9nJvCP0hCE2aeStnGSRedY6qp5qiHUiyES28ih+hjnbSC1r2ctdopxl5igv/9otMS3NazHzgpJqf98vrj2JFJ8AAAA=",
        "H4sIAAAAAAAAE02MOwqDQABE3WARiRASsAm6ZpGXFN6/3/KVltaeRFcIBIZhmN82p0wrD+nladEXmaSRsBBWwjZ3mZd85H0W0s+Pmc6CY5LkK3cZJf4VbjJY+Eg5H2q5LlQr1Q4DswNgfgAAAA==",
        "H4sIAAAAAAAAEzXKwQpAQBRGYROyESWiTLM7oXn//V3+S0vr+yRClt/peG6NWqwn4aLwh72ofiZjFptIYheLOEQU5TsEz4Mxikk0ovviDXEz8YBUAAAA",
        "H4sIAAAAAAAAEzWMuQoCMQAFs3iBghfIrieiTiH5/z7llFta50tMIrbvzUyOt8RW3nKVQaKcZSlhpPsQcjwkTvKUh2zk3vYuxyFVslhH6a2R+UhoV2nO5CJT2cmqMYsC/919YmJl1vL6WV9Y+2TtigAAAA==",
        "H4sIAAAAAAAAE/cCUoAtAAAA",
        "H4sIAAAAAAAAEzWOsQ7CMAxEEwEDUIREJYpU2gUeAoX/nz3e2JE5X0LiKpIX++7dOafR2Iut+IhJbMRO9AvxR8zpYvR+6UTyY8jpZnUt8xYHEcXQpNlq1EucxdPB4rmL00Jo7NHrvuLhntGl6OxQnGIWOHhdX2psZwSPql1/vz+QXroAAAA=",
      ]
    ]
    
    for (version, strings) in versionedStrings {
      for (index, string) in strings.enumerated() {
        do {
          let _ = try TelemetrySchema(gzippedBase64String: string)
        } catch let error {
          XCTFail("version: \(version) string \(index) - \(error.localizedDescription)")
        }
      }
    }

  }
    
}
