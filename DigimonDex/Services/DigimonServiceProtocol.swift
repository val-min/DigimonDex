//
//  DigimonServiceProtocol.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

protocol DigimonServiceProtocol {
    func fetchList(page: Int, pageSize: Int, filter: FilterOptions) async throws -> DigimonListResponse
    func fetchDetail(id: Int) async throws -> DigimonDetail
}
