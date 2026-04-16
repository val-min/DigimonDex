//
//  DigimonListView.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import SwiftUI

struct DigimonListView: View {
    @StateObject private var viewModel = DigimonListViewModel()
//    @StateObject private var viewModel: DigimonListViewModel
    init(service: DigimonServiceProtocol = DigimonService()) {
        _viewModel = StateObject(wrappedValue: DigimonListViewModel(service: service))
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.digiDark.ignoresSafeArea()
                
                switch viewModel.state {
                case .loading where viewModel.items.isEmpty:
                    loadingView
                case .error(let msg) where viewModel.items.isEmpty:
                    errorView(message: msg)
                default:
                    if viewModel.isEmpty {
                            emptyView
                        } else {
                            contentView
                        }
                }
            }
            .navigationTitle("DigimonDex")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            .sheet(isPresented: $viewModel.showFilters) {
                FilterSheetView(filter: $viewModel.filter)
            }
        }
        .onAppear { viewModel.onAppear() }
    }
    
    // MARK: - Content
    private var contentView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        DigimonDetailView(digimonId: item.id, name: item.name)
                    } label: {
                        DigimonCardView(item: item)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: item)
                    }
                }
                
                if viewModel.hasMore {
                    ProgressView()
                            .tint(.white.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .gridCellColumns(2)
                }
                
                if case .error(let msg) = viewModel.state, !viewModel.items.isEmpty {
                    paginationErrorView(message: msg)
                        .gridCellColumns(2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            Text("Loading Digimon...")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
        }
    }
    
    // Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.3))
            
            Text("No Digimon Found")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Try adjusting your filters")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
            
            Button {
                viewModel.filter.reset()
            } label: {
                Label("Clear Filters", systemImage: "xmark.circle")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(Color.digiDark)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.digiOrange)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadMoreIndicator: some View {
        HStack(spacing: 12) {
            ProgressView()
                .tint(.white.opacity(0.6))
            Text("Loading more...")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    // MARK: - Error
    private func errorView(message: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 56))
                .foregroundStyle(Color.digiOrange)
            
            Text("Connection Error")
                .font(.title2)
                .fontWeight(.bold)
//                .fontDesign(.rounded)
                .foregroundStyle(.white)
            
            Text(message)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: viewModel.retry) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.body)
                    .fontWeight(.bold)
//                    .fontDesign(.rounded)
                    .foregroundStyle(Color.digiDark)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Color.digiOrange)
                    .clipShape(Capsule())
            }
        }
    }
    
    private func paginationErrorView(message: String) -> some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.system(size: 13, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
            Button("Retry", action: viewModel.retry)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.digiOrange)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
    
    // MARK: - Filter Button
    private var filterButton: some View {
        Button { viewModel.showFilters = true } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                
                if viewModel.filter.isActive {
                    Circle()
                        .fill(Color.digiOrange)
                        .frame(width: 8, height: 8)
                        .offset(x: 4, y: -4)
                }
            }
        }
    }
}

#Preview() {
    DigimonListView(service: MockDigimonService())
}
