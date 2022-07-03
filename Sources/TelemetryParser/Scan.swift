//
//  Scan.swift
//  
//
//  Created by Vladislav Fitc on 27/01/2022.
//

import Foundation
import InstantSearchTelemetry
import ArgumentParser
import Darwin

struct Scan: ParsableCommand {
  
  @Argument(help: "file path")
  var filePath: String
    
  @Flag(name: [.long, .short], help: "human readable output")
  var humanReadable = false
  
  @Flag(name: [.long, .short], help: "debug mode")
  var debug = false
  
  func run() throws {
    var collector = TelemetryReducer()
    let fileScanner = FileScanner(filePath: filePath)

    try fileScanner { lineNumber, line in
      let components = line.split(separator: ",")
      guard components.count > 1 else { return }
      let appID = String(components[0])
      let rawTelemetry = String(components[1])
      let userAgents: String? = components.count > 2 ? String(components[2]) : nil
      let schema: TelemetrySchema
      do {
        schema = try TelemetrySchema(gzippedBase64String: rawTelemetry)
        collector.assign(schema: schema,
                         userAgents: userAgents,
                         forApplicationID: appID)
      } catch let error {
        if debug {
          print("line \(lineNumber)", error.localizedDescription, line)
        }
      }
    }
    
    if humanReadable {
      print(collector.stats)
    } else {
      print(collector.description)
    }

  }
  
  enum Error: LocalizedError {
    case fileError(Swift.Error)
    case telemetryFailure(Swift.Error, lineNumber: Int)
    
    var errorDescription: String? {
      switch self {
      case .fileError(let error):
        return "file issue: \(error.localizedDescription)"
      case .telemetryFailure(let error, lineNumber: let lineNumber):
        return "line \(lineNumber): \(error.localizedDescription)"
      }
    }
  }

}
