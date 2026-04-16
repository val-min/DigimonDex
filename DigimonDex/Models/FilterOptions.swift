//
//  FilterOptions.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

struct FilterOptions: Equatable {
    var name: String = ""
    var level: String = ""
    var attribute: String = ""
    var type_: String = ""
    var field: String = ""
    
    var isActive: Bool {
        !name.isEmpty || !level.isEmpty || !attribute.isEmpty || !type_.isEmpty || !field.isEmpty
    }
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if !name.isEmpty    { items.append(.init(name: "name", value: name)) }
        if !level.isEmpty   { items.append(.init(name: "level", value: level)) }
        if !attribute.isEmpty { items.append(.init(name: "attribute", value: attribute)) }
        // type and field are client-side filtered since API doesn't support combined queries
        return items
    }
    
    mutating func reset() {
        self = FilterOptions()
    }
}

// MARK: - Metadata for filter pickers
struct FilterMeta {
    static let levels = ["Fresh", "In-Training", "Rookie", "Champion", "Ultimate", "Mega", "Ultra", "Armor", "Hybrid", "Unknown"]
    static let attributes = ["Vaccine", "Data", "Virus", "Free", "Variable", "Unknown"]
    static let types = ["Free", "Bird Man", "Beast", "Dragon", "Dinosaur", "Insect", "Aquan", "Plant", "Machine", "Undead", "Holy Man", "Dark", "Unknown"]
}
