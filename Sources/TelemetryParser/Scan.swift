//
//  Scan.swift
//  
//
//  Created by Vladislav Fitc on 27/01/2022.
//

import Foundation
import InstantSearchTelemetry
import ArgumentParser

struct Scan: ParsableCommand {
  
  @Argument(help: "file path")
  var filePath: String
    
  @Flag
  var raw = false
  
  func run() throws {
    var collector = TelemetryReducer()
    let scanner = FileScanner(filePath: filePath)
    scanner { string in
      if
        let appID = parseApplicationID(from: string),
        let rawTelemetry = parseTelemetry(from: string),
        let schema = try? TelemetrySchema(gzippedBase64String: rawTelemetry) {
          collector.assign(schema: schema, forApplicationID: appID)
      }
    }
    if raw {
      print(collector.description)
    } else {
      print(collector.stats)
    }
  }
    
  func parseApplicationID(from string: String) -> String? {
    return string.split(separator: ",").first.flatMap(String.init)
  }
  
  func parseTelemetry(from string: String) -> String? {
    return string.split(separator: ",").last.flatMap(String.init)
  }
    
  enum Error: Swift.Error {
    case stringFromDataConversionFailure(Data)
  }

}
