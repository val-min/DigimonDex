//
//  DigimonService.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

final class DigimonService: DigimonServiceProtocol {
    
    private let network: NetworkManagerProtocol
    
    // Simple in-memory detail cache to avoid redundant fetches
    private var detailCache: [Int: DigimonDetail] = [:]
    
    init(network: NetworkManagerProtocol = NetworkManager.shared) {
        self.network = network
    }
    
    func fetchList(page: Int, pageSize: Int, filter: FilterOptions) async throws -> DigimonListResponse {
        guard let url = APIEndpoint.digimonList(page: page, pageSize: pageSize, filter: filter).url else {
            throw NetworkError.invalidURL
        }
        return try await network.fetch(DigimonListResponse.self, from: url)
    }
    
    func fetchDetail(id: Int) async throws -> DigimonDetail {
        if let cached = detailCache[id] { return cached }
        
        guard let url = APIEndpoint.digimonDetail(id: id).url else {
            throw NetworkError.invalidURL
        }
        let detail = try await network.fetch(DigimonDetail.self, from: url)
        detailCache[id] = detail
        return detail
    }
}
