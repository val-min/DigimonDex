//
//  APIEndPoints.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://digi-api.com/api/v1"
    
    case digimonList(page: Int, pageSize: Int, filter: FilterOptions)
    case digimonDetail(id: Int)
    
    var url: URL? {
        switch self {
        case .digimonList(let page, let pageSize, let filter):
            var components = URLComponents(string: "\(APIEndpoint.baseURL)/digimon")
            var items = filter.queryItems
            items.append(.init(name: "page", value: "\(page)"))
            items.append(.init(name: "pageSize", value: "\(pageSize)"))
            components?.queryItems = items
            return components?.url
            
        case .digimonDetail(let id):
            return URL(string: "\(APIEndpoint.baseURL)/digimon/\(id)")
        }
    }
}
