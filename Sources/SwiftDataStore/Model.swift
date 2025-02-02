//
//  Model.swift
//  SwiftDataStore
//
//  Created by Arkivili Collindort on 2025/2/2
//

import Foundation
import SwiftData

/// Data Store
///
/// - Note: Register this class to your model schema.
@Model
public class LocalDataStore: @unchecked Sendable {
    public var key: String
    
    public var value: Data
    
    /// Create a new `DataStore` by key and `Data` value.
    /// - Parameters:
    ///   - key: Key of the store
    ///   - value: `Data` raw value.
    public init(key: String, value: Data) {
        self.key = key
        self.value = value
    }
}
