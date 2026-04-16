//
//  DigimonDetail.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

struct DigimonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let xAntibody: Bool
    let images: [DigimonImage]
    let levels: [LevelItem]
    let types: [TypeItem]
    let attributes: [AttributeDetailItem]
    let fields: [FieldItem]
    let descriptions: [Description]
    let skills: [Skill]
    let priorEvolutions: [Evolution]
    let nextEvolutions: [Evolution]

    enum CodingKeys: String, CodingKey {
        case id, name, images, levels, types
        case attributes, fields, descriptions, skills
        case xAntibody       = "xAntibody"
        case priorEvolutions = "priorEvolutions"
        case nextEvolutions  = "nextEvolutions"
    }

    var primaryImage: String?        { images.first?.href }
    var primaryLevel: String         { levels.first?.level ?? "Unknown" }
    var primaryType: String          { types.first?.type ?? "Unknown" }
    var primaryAttribute: String     { attributes.first?.attribute ?? "Unknown" }
    var englishDescription: String {
        descriptions.first(where: { $0.language == "en_us" })?.description
        ?? descriptions.first?.description
        ?? "No description available."
    }
}

struct DigimonImage: Codable {
    let href: String
    let transparent: Bool
}

struct LevelItem: Codable, Identifiable {
    let id: Int
    let level: String
}

struct TypeItem: Codable, Identifiable {
    let id: Int
    let type: String
}

struct AttributeDetailItem: Codable, Identifiable {
    let id: Int
    let attribute: String
}

struct FieldItem: Codable, Identifiable {
    let id: Int
    let field: String
    let image: String
}

struct Description: Codable {
    let origin: String
    let language: String
    let description: String
}

struct Skill: Codable, Identifiable {
    let id: Int
    let skill: String
    let translation: String
    let description: String
}

struct Evolution: Codable, Identifiable {
    let id: Int
    let digimon: String
    let condition: String?
    let url: String
    let image: String
}
