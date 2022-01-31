//
//  FileScanner.swift
//  
//
//  Created by Vladislav Fitc on 31/01/2022.
//

import Foundation

struct FileScanner {
  
  let filePath: String
  
  init(filePath: String) {
    self.filePath = filePath
  }
  
  func callAsFunction(stringProcessor: (String) -> Void) {
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
    while bytesRead > 0 {
      
      // note: this translates the sequence of bytes to a string using UTF-8 interpretation
      var lineAsString = String(cString: lineByteArrayPointer!)
      if lineAsString.last == "\n" {
        lineAsString.removeLast()
      }

      stringProcessor(lineAsString)
            
      // updates number of bytes read, for the next iteration
      bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    }
  }
  
}
