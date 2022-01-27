//
//  Decode.swift
//  
//
//  Created by Vladislav Fitc on 27/01/2022.
//

import Foundation
import ArgumentParser
import InstantSearchTelemetry

struct Decode: ParsableCommand {
  
  @Argument(help: "base64 encoded gzipped string")
  var input: String
  
  func run() throws {
    let schema = try TelemetrySchema(gzippedBase64String: input)
    print(schema)
  }
  
  static func decode(_ input: String) throws -> TelemetrySchema {
    try TelemetrySchema(gzippedBase64String: input)
  }
    
}

