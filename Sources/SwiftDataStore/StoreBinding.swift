//
//  StoreBinding.swift
//  SwiftDataStore
//
//  Created by Arkivili Collindort on 2025/2/2
//

import Foundation

/// Store Binding
///
/// Extend this structure to make different bindings.
///
/// ```swift
/// extension StoreBinding where Value == String {
///     static let myBinding = StoreBinding(key: "my-binding", defaultValue: "Hello, World!")
/// }
/// ```
public struct StoreBinding<Value>: Sendable where Value: Codable & Sendable {
    @usableFromInline
    var key: String
    
    @usableFromInline
    var defaultValue: Value
    
    @inlinable
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    @inlinable
    public init<T>(key: String) where Value == Optional<T>, T: Codable & Sendable {
        self.key = key
        self.defaultValue = nil
    }
}
