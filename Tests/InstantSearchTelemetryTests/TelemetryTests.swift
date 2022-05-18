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
//  
//  func testCompression() throws {
//    let data = """
//    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit.
//    Ut velit mauris, egestas sed, gravida nec, ornare ut, mi. Aenean ut orci vel massa suscipit pulvinar. Nulla sollicitudin. Fusce varius, ligula non tempus aliquam, nunc turpis ullamcorper nibh, in tempus sapien eros vitae ligula. Pellentesque rhoncus nunc et augue. Integer id felis. Curabitur aliquet pellentesque diam. Integer quis metus vitae elit lobortis egestas. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi vel erat non mauris convallis vehicula. Nulla et sapien. Integer tortor tellus, aliquam faucibus, convallis id, congue eu, quam. Mauris ullamcorper felis vitae erat. Proin feugiat, augue non elementum posuere, metus purus iaculis lectus, et tristique ligula justo vitae magna.
//    Aliquam convallis sollicitudin purus. Praesent aliquam, enim at fermentum mollis, ligula massa adipiscing nisl, ac euismod nibh nisl eu lectus. Fusce vulputate sem at sapien. Vivamus leo. Aliquam euismod libero eu enim. Nulla nec felis sed leo placerat imperdiet. Aenean suscipit nulla in justo. Suspendisse cursus rutrum augue. Nulla tincidunt tincidunt mi. Curabitur iaculis, lorem vel rhoncus faucibus, felis magna fermentum augue, et ultricies lacus lorem varius purus. Curabitur eu amet.
//    """.data(using: .utf8)!
//    let compressed = data.gzip()
//    let pcompressed = try data.gzipped()
//    XCTAssertEqual(compressed, pcompressed)
//    let decompressed = try compressed.gunzip()
//    XCTAssertEqual(data, decompressed)
//    XCTAssertEqual(try compressed.gunzipped(), decompressed)
//  }
//  
//  func testGzipOursGunzipOurs() throws {
//    let schema = TelemetrySchema.with {
//      $0.components = TelemetryComponentType.allCases.map { type in
//        TelemetryComponent.with { w in
//          w.type = type
//          w.isConnector = true
//          w.parameters = Array(TelemetryComponentParams.allCases.shuffled()[..<5])
//        }
//      }
//    }
//    let data = try schema.serializedData()
//    let compressedData = data.gzip()
//    let uncompressedData = try compressedData.gunzip()
//    let decodedSchema = try TelemetrySchema(serializedData: uncompressedData)
//    XCTAssertEqual(schema, decodedSchema)
//  }
//  
//  func testGzipOursGunzipTheirs() throws {
//    let schema = TelemetrySchema.with {
//      $0.components = TelemetryComponentType.allCases.map { type in
//        TelemetryComponent.with { w in
//          w.type = type
//          w.isConnector = true
//          w.parameters = Array(TelemetryComponentParams.allCases.shuffled()[..<5])
//        }
//      }
//    }
//    let data = try schema.serializedData()
//    let compressed = data.gzip()
//    let uncompressed = try compressed.gunzipped()
//    let decodedSchema = try TelemetrySchema(serializedData: uncompressed)
//    XCTAssertEqual(schema, decodedSchema)
//  }
//  
//  func testGzipTheirsGunzipOurs() throws {
//    let schema = TelemetrySchema.with {
//      $0.components = TelemetryComponentType.allCases.map { type in
//        TelemetryComponent.with { w in
//          w.type = type
//          w.isConnector = true
//          w.parameters = Array(TelemetryComponentParams.allCases.shuffled()[..<5])
//        }
//      }
//    }
//    let data = try schema.serializedData()
//    let compressed = try data.gzipped()
//    let uncompressed = try compressed.gunzip()
//    let decodedSchema = try TelemetrySchema(serializedData: uncompressed)
//    XCTAssertEqual(schema, decodedSchema)
//  }
//  
}

//public extension Data {
//    private static let hexAlphabet = Array("0123456789abcdef".unicodeScalars)
//    func hexStringEncoded() -> String {
//        String(reduce(into: "".unicodeScalars) { result, value in
//            result.append(Self.hexAlphabet[Int(value / 0x10)])
//            result.append(Self.hexAlphabet[Int(value % 0x10)])
//        })
//    }
//}
