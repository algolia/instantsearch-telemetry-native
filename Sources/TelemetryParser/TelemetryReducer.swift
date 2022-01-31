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
        output += "\(appID) \(component.description)\n"
      }
    }
    return output
  }
  
}
