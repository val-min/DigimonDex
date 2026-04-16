//
//  DigimonDetailViewModel.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

@MainActor
final class DigimonDetailViewModel: ObservableObject {
    
    @Published private(set) var digimon: DigimonDetail?
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var selectedImageIndex: Int = 0
    
    private let service: DigimonServiceProtocol
    private let digimonId: Int
    
    init(digimonId: Int, service: DigimonServiceProtocol = DigimonService()) {
        self.digimonId = digimonId
        self.service = service
    }
    
    func onAppear() {
        guard digimon == nil else { return }
        fetch()
    }
    
    func retry() { fetch() }
    
    func selectImage(at index: Int) {
        selectedImageIndex = index
    }
    
    private func fetch() {
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                self.digimon = try await service.fetchDetail(id: digimonId)
                self.state = .loaded
            } catch {
                let msg = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                self.state = .error(msg)
            }
        }
    }
}
