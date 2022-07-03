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
    let userAgent: UserAgent
    
    init(name: String, isConnector: Bool, parameters: Set<String>, userAgent: String) {
      self.name = name
      self.isConnector = isConnector
      self.parameters = parameters
      self.userAgent = UserAgent(rawValue: userAgent)
    }

    init(_ telemetryComponent: TelemetryComponent, userAgent: String) {
      self.init(name: "\(telemetryComponent.type)",
                isConnector: telemetryComponent.isConnector,
                parameters: Set(telemetryComponent.parameters.map { "\($0)" }),
                userAgent: userAgent)
    }
    
  }

}

extension TelemetryReducer.Component: CustomStringConvertible {
  
  var description: String {
    let isConnectorString = isConnector ? "1" : "0"
    let paramsString = parameters.sorted().joined(separator: ",")
    return "\(name),\(isConnectorString),\"\(paramsString)\",\(userAgent.description)"
  }
    
}
