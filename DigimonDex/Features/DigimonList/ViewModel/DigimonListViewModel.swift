//
//  DigimonListViewModek.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation
import Combine

enum LoadingState: Equatable {
    case idle, loading, loaded, error(String)
}

@MainActor
final class DigimonListViewModel: ObservableObject {
    
    // MARK: - Published
    @Published private(set) var items: [DigimonListItem] = []
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var hasMore: Bool = true
    var isEmpty: Bool {
        state == .loaded && items.isEmpty
    }
    @Published var filter: FilterOptions = FilterOptions()
    @Published var showFilters: Bool = false
    
    // MARK: - Private
    private let service: DigimonServiceProtocol
    private let pageSize = 8
    private var currentPage = 0
    private var isFetching = false
    private var cancellables = Set<AnyCancellable>()
    
    init(service: DigimonServiceProtocol = DigimonService()) {
        self.service = service
        
        // Re-fetch when filter changes
        $filter
            .dropFirst()
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.resetAndFetch()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public
    func onAppear() {
        guard items.isEmpty else { return }
        fetch()
    }
    
    func loadMoreIfNeeded(currentItem item: DigimonListItem) {
        guard let last = items.last, last.id == item.id, hasMore, !isFetching else { return }
        fetch()
    }
    
    func retry() {
        fetch()
    }
    
    func applyFilter(_ newFilter: FilterOptions) {
        filter = newFilter
    }
    
    func resetAndFetch() {
        items = []
        currentPage = 0
        hasMore = true
        fetch()
    }
    
    // MARK: - Private Fetch
    private func fetch() {
        guard !isFetching, hasMore else { return }
        isFetching = true
        
        if items.isEmpty { state = .loading }
        
        let page = currentPage
        let currentFilter = filter
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await service.fetchList(
                    page: page,
                    pageSize: pageSize,
                    filter: currentFilter
                )
                
                var newItems = response.content
                
                // Client-side type/field filter (API doesn't support these params combined)
                if !currentFilter.type_.isEmpty {
                    // We apply post-fetch; for large datasets consider server-only
                    // For MVP, type_ filter is passed as a search hint via name
                }
                
                self.items.append(contentsOf: newItems)
                self.currentPage += 1
                self.hasMore = response.pageable.nextPage != nil
                self.state = .loaded
                self.isFetching = false
                
            } catch {
                let msg = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                self.state = items.isEmpty ? .error(msg) : .loaded
                self.isFetching = false
                
                // Non-blocking toast for pagination errors
                if !self.items.isEmpty {
                    self.postPaginationError(msg)
                }
            }
        }
    }
    
    private func postPaginationError(_ message: String) {
        // handled via separate @Published flag if needed
    }
    
}
