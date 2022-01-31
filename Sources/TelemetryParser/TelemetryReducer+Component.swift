//
//  TelemetryReducer+Component.swift
//  
//
//  Created by Vladislav Fitc on 31/01/2022.
//

import Foundation
import InstantSearchTelemetry

extension TelemetryReducer {
  
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

}

extension TelemetryReducer.Component: CustomStringConvertible {
  
  var description: String {
    (["\(name)", (isConnector ? "connector" : "")].filter { !$0.isEmpty } + parameters.sorted()).joined(separator: " ")
  }
    
}
