//
//  TelemetryReducer.swift
//  
//
//  Created by Vladislav Fitc on 31/01/2022.
//

import Foundation
import InstantSearchTelemetry

struct TelemetryReducer {
  
  typealias ApplicationID = String
  typealias ComponentName = String
  
  private var data: [ApplicationID: [ComponentName: Component]] = [:]
  
  mutating func assign(schema: TelemetrySchema, forApplicationID applicationID: ApplicationID) {
    let components = schema.components.map(Component.init)
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
}

extension TelemetryReducer: CustomStringConvertible {
  
  var description: String {
    var output = ""
    for (appID, components) in data {
      for (_, component) in components.sorted(by: { $0.key < $1.key }) {
        output += "\(appID),\(component.description)\n"
      }
    }
    return output
  }
  
}

extension TelemetryReducer {
  
  struct ComponentStats {
    var count: Int
    var connectorsCount: Int
    var paramsCount: [String: Int]
    
    init(_ component: TelemetryReducer.Component) {
      self.count = 1
      self.connectorsCount = component.isConnector ? 1 : 0
      self.paramsCount = .init(uniqueKeysWithValues: component.parameters.map { ($0, 1) })
    }
    
    func apply(_ component: TelemetryReducer.Component) -> ComponentStats {
      var selfCopy = self
      selfCopy.count += 1
      if component.isConnector {
        selfCopy.connectorsCount += 1
      }
      for param in component.parameters {
        selfCopy.paramsCount[param] = (paramsCount[param] ?? 0) + 1
      }
      return selfCopy
    }
    
    var description: String {
      var output = ""
      output.append("\n usages: \(count)")
      output.append("\n usages as connector: \(connectorsCount)")
      let paramsString = paramsCount
        .sorted(by: { $0.value > $1.value })
        .map { "\($0): \($1)" }
        .joined(separator: "\n  ")
      if paramsString.isEmpty {
        output.append("\n parameters: no parameters")
      } else {
        output.append("\n parameters: \n  \(paramsString)")
      }
      return output
    }
    
  }
  
  var stats: String {
    var output = ""
    output.append("total applications count: \(data.count)\n\n")
    var statsDict: [String: ComponentStats] = [:]
    for component in data.values.flatMap(\.values) {
      statsDict[component.name] = statsDict[component.name].flatMap { $0.apply(component) } ?? ComponentStats(component)
    }
    let statsOutput = statsDict
      .sorted { $0.value.count > $1.value.count }
      .map { "\($0.key)\($0.value.description)" }
      .joined(separator: "\n\n")
    output.append(statsOutput)
    return output
  }
  
}
