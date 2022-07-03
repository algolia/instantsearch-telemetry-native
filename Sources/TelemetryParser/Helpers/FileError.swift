//
//  FileError.swift
//  
//
//  Created by Vladislav Fitc on 01/07/2022.
//

import Foundation

enum FileError: LocalizedError {
  case fileNotFound(String)
  case fileCannotBeOpen(String)
  
  var errorDescription: String? {
    switch self {
    case .fileNotFound(let path):
      return "file expected at \(path) is missing"
    case .fileCannotBeOpen(let path):
      return "file at \(path) cannot be opened"
    }
  }
}
