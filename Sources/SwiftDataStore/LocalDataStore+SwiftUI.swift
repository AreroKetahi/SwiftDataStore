//
//  LocalDataStore+SwiftUI.swift
//  Score-Control-X
//
//  Created by Arkivili Collindort on 2025/2/17
//

import SwiftUI
import SwiftData

public struct DSView<Content, Value>: View where Content: View, Value: Codable & Sendable {
    @Environment(\.modelContext) var modelContext
    @Query var stores: [LocalDataStore]
    
    var content: (Value) -> Content
    
    private var key: String
    private var defaultValue: Value
    
    var value: Value {
        return try! store.get(as: Value.self)
    }
    
    var store: LocalDataStore {
        if let store = stores.first(where: { $0.key == key }) {
            return store
        } else {
            let newStore = try! LocalDataStore(key: key, value: defaultValue)
            modelContext.insert(newStore)
            return newStore
        }
    }
    
    public var body: some View {
        content(value)
    }
    
    public init(
        key: String,
        defaultValue: Value,
        content: @escaping (Value) -> Content
    ) {
        self.content = content
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public init(
        with binding: StoreBinding<Value>,
        content: @escaping (Value) -> Content
    ) {
        self.content = content
        self.key = binding.key
        self.defaultValue = binding.defaultValue
    }
}

public struct DSBinding<Content, Value>: View where Content: View, Value: Codable & Sendable {
    @Environment(\.modelContext) var modelContext
    @Query var stores: [LocalDataStore]
    
    var content: (Binding<Value>) -> Content
    
    private var key: String
    private var defaultValue: Value
    
    var binding: Binding<Value> {
        return .init {
            try! store.get()
        } set: { newValue in
            try! store.write(newValue)
        }
    }
    
    var store: LocalDataStore {
        if let store = stores.first(where: { $0.key == key }) {
            return store
        } else {
            let newStore = try! LocalDataStore(key: key, value: defaultValue)
            modelContext.insert(newStore)
            return newStore
        }
    }
    
    public var body: some View {
        content(binding)
    }
    
    public init(
        key: String,
        defaultValue: Value,
        content: @escaping (Binding<Value>) -> Content
    ) {
        self.content = content
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public init(
        with binding: StoreBinding<Value>,
        content: @escaping (Binding<Value>) -> Content
    ) {
        self.content = content
        self.key = binding.key
        self.defaultValue = binding.defaultValue
    }
}
