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
    
    // For mock/testing
        init(content: [DigimonListItem], pageable: Pageable) {
            self.content = content
            self.pageable = pageable
        }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            content = (try? container.decode([DigimonListItem].self, forKey: .content)) ?? []
            pageable = try container.decode(Pageable.self, forKey: .pageable)
        }
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

//    enum CodingKeys: String, CodingKey {
//        case currentPage     = "currentPage"
//        case elementsOnPage  = "elementsOnPage"
//        case totalElements   = "totalElements"
//        case totalPages      = "totalPages"
//        case previousPage    = "previousPage"
//        case nextPage        = "nextPage"
//    }
    
    // For mock/testing
        init(currentPage: Int = 0, elementsOnPage: Int = 2,
             totalElements: Int = 2, totalPages: Int = 1,
             previousPage: String? = nil, nextPage: String? = nil) {
            self.currentPage = currentPage
            self.elementsOnPage = elementsOnPage
            self.totalElements = totalElements
            self.totalPages = totalPages
            self.previousPage = previousPage
            self.nextPage = nextPage
        }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            currentPage = (try? container.decode(Int.self, forKey: .currentPage)) ?? 0
            elementsOnPage = (try? container.decode(Int.self, forKey: .elementsOnPage)) ?? 0
            totalElements = (try? container.decode(Int.self, forKey: .totalElements)) ?? 0
            totalPages = (try? container.decode(Int.self, forKey: .totalPages)) ?? 0
            previousPage = try? container.decode(String.self, forKey: .previousPage)
            nextPage = try? container.decode(String.self, forKey: .nextPage)
        }
}
