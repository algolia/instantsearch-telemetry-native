//
//  Scan.swift
//  
//
//  Created by Vladislav Fitc on 27/01/2022.
//

import Foundation
import ArgumentParser
import InstantSearchTelemetry

struct Scan: ParsableCommand {
  
  @Argument(help: "file path")
  var filePath: String
    
  static let telemetryExtractor: RegexExtractor = "ISTelemetry\\((?<telemetry>.+)\\)"
  
  func run() throws {
    printLineByLine(filePath: filePath)
  }
  
  func printLineByLine(filePath: String) {
    let fileURL = URL(fileURLWithPath: filePath)
    
    // make sure the file exists
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      preconditionFailure("file expected at \(fileURL.absoluteString) is missing")
    }
    
    // open the file for reading
    // note: user should be prompted the first time to allow reading from this location
    guard let filePointer:UnsafeMutablePointer<FILE> = fopen(fileURL.path, "r") else {
      preconditionFailure("Could not open file at \(fileURL.absoluteString)")
    }
    
    // a pointer to a null-terminated, UTF-8 encoded sequence of bytes
    var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
    
    defer {
      // remember to close the file when done
      fclose(filePointer)
      
      // The buffer should be freed by even if getline() failed.
      lineByteArrayPointer?.deallocate()
    }
    
    // the smallest multiple of 16 that will fit the byte array for this line
    var lineCap: Int = 0
    
    // initial iteration
    var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    var collector = TelemetryCollector()
    while bytesRead > 0 {
      
      // note: this translates the sequence of bytes to a string using UTF-8 interpretation
      var lineAsString = String(cString: lineByteArrayPointer!)
      if lineAsString.last == "\n" {
        lineAsString.removeLast()
      }
      
      // do whatever you need to do with this single line of text
      // for debugging, can print it
      print(lineAsString)
      let appID = parseApplicationID(from: lineAsString)
      let rawTelemetry = parseTelemetry(from: lineAsString)
      if let schema = try? TelemetrySchema(gzippedBase64String: rawTelemetry) {
        let components = schema.components.map(Component.init)
        collector.assign(components: components, forApplicationID: appID)
      }
            
      // updates number of bytes read, for the next iteration
      bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    }
    
    collector.output()
    
  }
    
  func parseApplicationID(from string: String) -> String {
    return string.split(separator: ",").first.flatMap(String.init) ?? ""
  }
  
  func parseTelemetry(from string: String) -> String {
    return Scan.telemetryExtractor(string, rangeName: "telemetry").first ?? ""
  }
    
  enum Error: Swift.Error {
    case stringFromDataConversionFailure(Data)
  }

}

struct TelemetryCollector {
  
  var data: [String: [String: Component]] = [:]
  
  mutating func assign(components: [Component], forApplicationID applicationID: String) {
    var appComponents = data[applicationID] ?? [:]
    for component in components {
      if let existingComponent = appComponents[component.name] {
        appComponents[component.name] = existingComponent.merging(component)
      } else {
        appComponents[component.name] = component
      }
    }
    data[applicationID] = appComponents
  }
  
  func output() {
    for (appID, components) in data {
      for (_, component) in components.sorted(by: { $0.key < $1.key }) {
        print(appID, component.description)
      }
    }
  }
  
}

struct Component: Hashable {
  
  let name: String
  let isConnector: Bool
  let parameters: Set<String>
  
  init(name: String, isConnector: Bool, parameters: Set<String>) {
    self.name = name
    self.isConnector = isConnector
    self.parameters = parameters
  }

  init(_ telemetryComponent: TelemetryComponent) {
    self.init(name: "\(telemetryComponent.type)",
              isConnector: telemetryComponent.isConnector,
              parameters: Set(telemetryComponent.parameters.map { "\($0)" }))
  }
    
  func merging(_ component: Component) -> Component {
    guard component.name == name else { fatalError() }
    let isConnector = isConnector || component.isConnector
    let parameters = parameters.union(component.parameters)
    return Component(name: name, isConnector: isConnector, parameters: parameters)
  }
  
}

extension Component: CustomStringConvertible {
  
  var description: String {
    (["\(name)", (isConnector ? "connector" : "")].filter { !$0.isEmpty } + parameters.sorted()).joined(separator: " ")
  }
  
}
