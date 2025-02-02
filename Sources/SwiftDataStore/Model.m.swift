//
//  Model.m.swift
//  SwiftDataStore
//
//  Created by Arkivili Collindort on 2025/2/2
//

import Foundation
import SwiftData

extension LocalDataStore {
    /// Create a `DataStore` by any `Encodable` value.
    /// - Parameters:
    ///   - key: Key of the store.
    ///   - value: `Encodable` value that initialize to store.
    @inlinable
    public convenience init<T>(key: String, value: T) throws where T: Encodable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        self.init(key: key, value: data)
    }
    
    /// Get value and decode to a specific type.
    /// - Parameter type: `Decodable` type that need to decode to.
    /// - Returns: Decoded value.
    @inlinable
    public func get<T>(as type: T.Type = T.self) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: value)
    }
    
    /// Write a `Encodable` value to store.
    /// - Parameter value: `Encodable` new value.
    @inlinable
    public func write<T>(_ value: T) throws where T: Encodable {
        let encoder = JSONEncoder()
        self.value = try encoder.encode(value)
    }
}

extension LocalDataStore {
    /// Write raw value to specific store.
    ///
    /// - Note: If the data store is not exist, a new data store will be created.
    ///
    /// - Parameters:
    ///   - key: Key of the store.
    ///   - newValue: New raw value that need to write.
    ///   - context: SwiftData model context.
    @inlinable
    public static func writeValue(
        key: String,
        newValue: Data,
        in context: ModelContext
    ) throws {
        let store = try get(key: key, defaultValue: newValue, in: context)
        
        store.value = newValue
        
        try context.save()
    }
    
    /// Write value to specific store.
    ///
    /// - Note: If the data store is not exist, a new data store will be created.
    ///
    /// - Parameters:
    ///   - key: Key of the store.
    ///   - newValue: New value that need to write.
    ///   - context: SwiftData model context.
    @inlinable
    public static func writeValue<T>(
        key: String,
        newValue: T,
        in context: ModelContext
    ) throws where T: Encodable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(newValue)
        try self.writeValue(key: key, newValue: data, in: context)
    }
    
    /// Write value to specific store.
    /// - Parameters:
    ///   - binding: Store binding identifier.
    ///   - newValue: New value that need to write.
    ///   - context: SwiftData model context.
    @inlinable
    public static func writeValue(
        with binding: StoreBinding<Data>,
        newValue: Data,
        in context: ModelContext
    ) throws {
        try self.writeValue(
            key: binding.key,
            newValue: newValue,
            in: context
        )
    }
    
    /// Write value to specific store.
    /// - Parameters:
    ///   - binding: Store binding identifier.
    ///   - newValue: New value that need to write.
    ///   - context: SwiftData model context.
    @inlinable
    public static func writeValue<T>(
        with binding: StoreBinding<T>,
        newValue: T,
        in context: ModelContext
    ) throws where T: Encodable {
        try self.writeValue(
            key: binding.key,
            newValue: newValue,
            in: context
        )
    }
}

extension LocalDataStore {
    /// Get a store
    /// - Parameters:
    ///   - key: Key of the store.
    ///   - defaultValue: Default value that initialize the store if the store is not exist.
    ///   - context: SwiftData model context.
    /// - Returns: Specific data store.
    @inlinable
    public static func get(
        key: String,
        defaultValue: Data,
        in context: ModelContext
    ) throws -> LocalDataStore {
        let descriptor = FetchDescriptor<LocalDataStore>(
            predicate: #Predicate { model in
                model.key == key
            }
        )
        let results = try context.fetch(descriptor)
        if let store = results.first {
            return store
        } else {
            let newDataStore = LocalDataStore(key: key, value: defaultValue)
            context.insert(newDataStore)
            return newDataStore
        }
    }
    
    /// Get a store
    /// - Parameters:
    ///   - key: Key of the store.
    ///   - defaultValue: Default value that initialize the store if the store is not exist.
    ///   - context: SwiftData model context.
    /// - Returns: Specific data store.
    @inlinable
    public static func get<T>(
        key: String,
        defaultValue: T,
        in context: ModelContext
    ) throws -> LocalDataStore where T: Encodable {
        let encoder = JSONEncoder()
        let defaultValue = try encoder.encode(defaultValue)
        return try self.get(
            key: key,
            defaultValue: defaultValue,
            in: context
        )
    }
    
    /// Get a store
    /// - Parameters:
    ///   - binding: Store binding identifier.
    ///   - context: SwiftData model context.
    /// - Returns: Specific data store.
    @inlinable
    public static func get<T>(
        with binding: StoreBinding<T>,
        in context: ModelContext
    ) throws -> LocalDataStore where T: Encodable {
        return try self.get(
            key: binding.key,
            defaultValue: binding.defaultValue,
            in: context
        )
    }
}

extension LocalDataStore {
    /// Directly get the value
    /// - Parameters:
    ///   - key: Key of the store
    ///   - defaultValue: Default value that initialize the store if the store is not exist.
    ///   - context: SwiftData model context.
    /// - Returns: Value of the store
    @inlinable
    public static func getValue(
        key: String,
        defaultValue: Data,
        in context: ModelContext
    ) throws -> Data {
        let store = try self.get(
            key: key,
            defaultValue: defaultValue,
            in: context
        )
        return store.value
    }
    
    /// Directly get the value
    /// - Parameters:
    ///   - key: Key of the store
    ///   - defaultValue: Default value that initialize the store if the store is not exist.
    ///   - context: SwiftData model context.
    /// - Returns: Value of the store
    @inlinable
    public static func getValue<T>(
        key: String,
        defaultValue: T,
        in context: ModelContext
    ) throws -> T where T: Codable {
        let encoder = JSONEncoder()
        let defaultValue = try encoder.encode(defaultValue)
        
        let data = try self.getValue(
            key: key,
            defaultValue: defaultValue,
            in: context
        )
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    /// Directly get the value
    /// - Parameters:
    ///   - binding: Store binding identifier.
    ///   - defaultValue: Default value that initialize the store if the store is not exist.
    ///   - context: SwiftData model context.
    /// - Returns: Value of the store
    @inlinable
    public static func getValue<T>(
        with binding: StoreBinding<T>,
        in context: ModelContext
    ) throws -> T where T: Encodable {
        try self.getValue(key: binding.key, defaultValue: binding.defaultValue, in: context)
    }
}

extension LocalDataStore {
    /// Assert if the specific store is exist.
    /// - Parameters:
    ///   - key: Key of the store.
    ///   - context: SwiftData model context.
    /// - Returns: `true` if the store exist, otherwise `false`.
    @inlinable
    public static func exist(where key: String, in context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<LocalDataStore>(
            predicate: #Predicate { store in
                store.key == key
            }
        )
        
        guard let result = try? context.fetch(descriptor).count else {
            return false
        }
        return result > 0
    }
    
    /// Assert if the specific store is exist.
    /// - Parameters:
    ///   - binding: Store binding identifier.
    ///   - context: SwiftData model context.
    /// - Returns: `true` if the store exist, otherwise `false`.
    @inlinable
    public static func exist<T>(where binding: StoreBinding<T>, in context: ModelContext) -> Bool {
        self.exist(where: binding.key, in: context)
    }
}

