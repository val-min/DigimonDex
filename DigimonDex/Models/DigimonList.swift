//
//  DigimonList.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

struct DigimonListResponse: Codable {
    let content: [DigimonListItem]
    let pageable: Pageable
}

struct DigimonListItem: Codable, Identifiable {
    let id: Int
    let name: String
    let href: String
    let image: String
}

struct Pageable: Codable {
    let currentPage: Int
    let elementsOnPage: Int
    let totalElements: Int
    let totalPages: Int
    let previousPage: String?
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case currentPage     = "currentPage"
        case elementsOnPage  = "elementsOnPage"
        case totalElements   = "totalElements"
        case totalPages      = "totalPages"
        case previousPage    = "previousPage"
        case nextPage        = "nextPage"
    }
}
