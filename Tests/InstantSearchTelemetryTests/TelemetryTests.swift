import XCTest
@testable import InstantSearchTelemetry

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
    let rawTelemetryStrings = [
      "H4sIAAAAAAAAE3ukLXRAlfEECDGdUGU7oap1QZXxkTbbAVXWC6oMj7Q5D6hynFDVBgsC2YJICoTBCoAMEaAIABhKRiRIAAAA",
      "H4sIAAAAAAAAAHukzXZAlfGCKsMjEEMExmCFMTguqDICAIzMnTMkAAAA",
      "H4sIAAAAAAAAAHukzXZAlfGCKsMjEEMExhC+oMoIAGuHg1AbAAAA",
      "H4sIAAAAAAAAE3ukzXZAlfmCKgMAAAIDWgkAAAA=",
      "H4sIAAAAAAAAE3ukzX9AlfEECDGdUGW7oMrwSJvtgCormMFzQJXjhCr7CVUJmLggjCECZAAAlZEs0zwAAAA=",
      "H4sIAAAAAAAAAHukzXZAlfWCKsMjEIMRzOA8oMpxQlXigiojAP1WSJgeAAAA",
      "H4sIAAAAAAAAE3ukzXZAlfWCKgMA3F1ofwkAAAA=",
      "H4sIAAAAAAAAE3ukzX9AlfEECDGdUGW7oMrwSJvtgCormMFzQJXthCrnCVXJC6qMj7Q5D6hynFDVBrOBajhhigVhDCGYlDCMIQJkAADFQJdBYwAAAA==",
      "H4sIAAAAAAAAAHukzXZAlfGCKsMjEEMExhC+oMoIZrCCRTgPqHKcUJUACgIAjBiI0jAAAAA=",
    ]
    
    for (index, string) in rawTelemetryStrings.enumerated() {
      
      guard let compressedData = Data(base64Encoded: string) else {
        XCTFail("Base64 decoding failed: \(index)")
        return
      }
      
      let uncompressedData: Data
      do {
        uncompressedData = try compressedData.gunzipped()
      } catch let unzipError {
        XCTFail("Unzip failed  [\(index)]: \(unzipError)")
        return
      }
      
      do {
        _ = try TelemetrySchema(serializedData: uncompressedData)
      } catch let deserializationError {
        XCTFail("Telemetry decoding failed [\(index)]: \(deserializationError)")
        return
      }
      
    }
  }
  
}
