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
    let compressedData = try data.gzipped()
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

}
