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
  
  @Argument(help: "base64 encoded gzipped telemetry string")
  var input: String
  
  func run() throws {
    let components = try TelemetrySchema(gzippedBase64String: input).components.map(TelemetryReducer.Component.init)
    for component in components {
      print(component.description)
    }
  }
    
}

