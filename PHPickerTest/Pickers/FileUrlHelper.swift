//
//  File.swift
//  
//
//  Created by Anton on 27.07.2021.
//

import Foundation

extension URL {
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch {
            print("File attribute error: \(error.localizedDescription)")
        }
        return nil
    }
    
    var fileSize: Int64 {
        return attributes?[.size] as? Int64 ?? Int64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
    
    var fileName: String {
        return self.lastPathComponent
    }
}
