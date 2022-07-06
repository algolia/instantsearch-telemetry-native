//
//  UserAgent.swift
//  
//
//  Created by Vladislav Fitc on 01/07/2022.
//

import Foundation

struct UserAgent: Hashable, CustomStringConvertible {
  
  let androidVersion: String?
  let iosVersion: String?
  let swiftClientVersion: String?
  let kotlinClientVersion: String?
  let iosInstantSearchVersion: String?
  let androidInstantSearchVersion: String?
  
  init() {
    self.androidVersion = nil
    self.iosVersion = nil
    self.swiftClientVersion = nil
    self.kotlinClientVersion = nil
    self.iosInstantSearchVersion = nil
    self.androidInstantSearchVersion = nil
  }
  
  init(rawValue: String) {
    let rawUserAgents = rawValue
      .split(separator: ";", omittingEmptySubsequences: true)
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    func extractVersion(_ prefix: String) -> String? {
      for rawUserAgent in rawUserAgents where rawUserAgent.starts(with: prefix) {
        return String(rawUserAgent.dropFirst(prefix.count).dropLast())
      }
      return nil
    }
    androidVersion = extractVersion("Android (")
    iosVersion = extractVersion("iOS (")
    swiftClientVersion = extractVersion("Algolia for Swift (")
    kotlinClientVersion = extractVersion("Algolia for Kotlin (")
    iosInstantSearchVersion = extractVersion("InstantSearch iOS (")
    androidInstantSearchVersion = extractVersion("InstantSearchAndroid (")
  }
  
  var description: String {
    [
      androidVersion,
      kotlinClientVersion,
      androidInstantSearchVersion,
      iosVersion,
      swiftClientVersion,
      iosInstantSearchVersion
    ]
      .map { $0 ?? "undefined" }
      .joined(separator: ",")
  }
  
}
