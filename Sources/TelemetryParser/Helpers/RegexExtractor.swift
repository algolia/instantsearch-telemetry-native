//
//  RegexExtractor.swift
//  
//
//  Created by Vladislav Fitc on 27/01/2022.
//

import Foundation

class RegexExtractor: ExpressibleByStringInterpolation {
  
  let regularExpression: NSRegularExpression
  
  init(regularExpression: NSRegularExpression) {
    self.regularExpression = regularExpression
  }
  
  convenience init(pattern: String, options: NSRegularExpression.Options = []) throws {
    self.init(regularExpression: try NSRegularExpression(pattern: pattern, options: options))
  }
  
  required init(stringLiteral value: String) {
    self.regularExpression = try! NSRegularExpression(pattern: value, options: [])
  }
  
  func callAsFunction(_ input: String) -> [String] {
    let inputRange = NSRange(input.startIndex..<input.endIndex, in: input)
    var output: [String] = []
    for match in regularExpression.matches(in: input, options: [], range: inputRange) {
      let matchRange = Range(match.range, in: input)!
      output.append(String(input[matchRange]))
    }
    return output
  }
  
  func callAsFunction(_ input: String, rangeName: String) -> [String] {
    let inputRange = NSRange(input.startIndex..<input.endIndex, in: input)
    var output: [String] = []
    for match in regularExpression.matches(in: input, options: [], range: inputRange) {
      if let range = Range(match.range(withName: rangeName), in: input) {
        output.append(String(input[range]))
      }
    }
    return output
  }
  
}
