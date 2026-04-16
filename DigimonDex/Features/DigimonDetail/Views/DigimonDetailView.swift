//
//  DigimonDetailView.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct DigimonDetailView: View {
    let digimonId: Int
    let name: String
    
    @StateObject private var viewModel: DigimonDetailViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    init(digimonId: Int, name: String, service: DigimonServiceProtocol = DigimonService()) {
            self.digimonId = digimonId
            self.name = name
            self._viewModel = StateObject(
                wrappedValue: DigimonDetailViewModel(digimonId: digimonId, service: service)
            )
        }
    
    var body: some View {
        ZStack {
            Color.digiDark.ignoresSafeArea()
            
            switch viewModel.state {
            case .loading:
                loadingView
            case .error(let msg):
                errorView(message: msg)
            case .loaded, .idle:
                if let digi = viewModel.digimon {
                    detailContent(digi)
                }
            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { viewModel.onAppear() }
    }
    
    // MARK: - Detail Content
    private func detailContent(_ digi: DigimonDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // Hero image section
                heroSection(digi)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Stat badges
                    statBadges(digi)
                    
                    // Description
                    if !digi.englishDescription.isEmpty {
                        sectionCard(title: "About") {
                            Text(digi.englishDescription)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                    }
                    
                    // Fields
                    if !digi.fields.isEmpty {
                        fieldsSection(digi.fields)
                    }
                    
                    // Skills
                    if !digi.skills.isEmpty {
                        skillsSection(digi.skills)
                    }
                    
                    // Evolutions
                    if !digi.priorEvolutions.isEmpty {
                        evolutionSection(title: "Digivolves from", evolutions: digi.priorEvolutions)
                    }
                    if !digi.nextEvolutions.isEmpty {
                        evolutionSection(title: "Digivolves to", evolutions: digi.nextEvolutions)
                    }
                }
                .padding(16)
                .padding(.bottom, 32)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Hero
    private func heroSection(_ digi: DigimonDetail) -> some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [Color.digiBlue.opacity(0.6), Color.digiDark],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 300)
            
            let imageURL = digi.images.indices.contains(viewModel.selectedImageIndex)
                ? URL(string: digi.images[viewModel.selectedImageIndex].href)
                : URL(string: digi.primaryImage ?? "")
            
            WebImage(url: imageURL)
                .resizable()
                .scaledToFit()
                .frame(height: 260)
                .shadow(color: Color.digiBlue.opacity(0.5), radius: 20)
            
            // Image selector dots
            if digi.images.count > 1 {
                HStack(spacing: 6) {
                    ForEach(digi.images.indices, id: \.self) { idx in
                        Button { viewModel.selectImage(at: idx) } label: {
                            Circle()
                                .fill(viewModel.selectedImageIndex == idx ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .padding(.bottom, 8)
            }
        }
    }
    
    // MARK: - Stat Badges
    private func statBadges(_ digi: DigimonDetail) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                statBadge(icon: "chart.bar.fill", label: digi.primaryLevel,
                          color: Color.levelColor(digi.primaryLevel))
                statBadge(icon: "shield.fill", label: digi.primaryAttribute, color: .cyan)
                statBadge(icon: "tag.fill", label: digi.primaryType, color: .indigo)
                if digi.xAntibody {
                    statBadge(icon: "staroflife.fill", label: "X-Antibody", color: .yellow)
                }
            }
        }
    }
    
    private func statBadge(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(color.opacity(0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .clipShape(Capsule())
    }
    
    // MARK: - Fields
    private func fieldsSection(_ fields: [FieldItem]) -> some View {
        sectionCard(title: "Fields") {
            FlowLayout(spacing: 8) {
                ForEach(fields) { field in
                    HStack(spacing: 6) {
                        WebImage(url: URL(string: field.image))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(field.field)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Capsule())
                }
            }
        }
    }
    
    // MARK: - Skills
    private func skillsSection(_ skills: [Skill]) -> some View {
        sectionCard(title: "Skills") {
            VStack(spacing: 12) {
                ForEach(skills) { skill in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(skill.skill)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.digiOrange)
                        Text(skill.description)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if skill.id != skills.last?.id {
                        Divider().background(Color.white.opacity(0.1))
                    }
                }
            }
        }
    }
    
    // MARK: - Evolutions
    private func evolutionSection(title: String, evolutions: [Evolution]) -> some View {
        sectionCard(title: title) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(evolutions) { evo in
                        VStack(spacing: 6) {
                            WebImage(url: URL(string: evo.image))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text(evo.digimon)
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(width: 70)
                            
                            if let cond = evo.condition, !cond.isEmpty {
                                Text(cond)
                                    .font(.system(size: 9, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.45))
                                    .lineLimit(1)
                                    .frame(width: 70)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Section Card Helper
    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(Color.digiBlue)
                .tracking(1.5)
            
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    // MARK: - Loading / Error
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView().tint(.white)
            Text("Loading \(name)…")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.digiOrange)
            Text(message)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button("Retry", action: viewModel.retry)
                .font(.system(.body, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24).padding(.vertical, 10)
                .background(Color.digiBlue)
                .clipShape(Capsule())
        }
    }
}

// MARK: - FlowLayout (for tags)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var currentX: CGFloat = 0, currentY: CGFloat = 0, rowHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0; currentY += rowHeight + spacing; rowHeight = 0
            }
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: currentY + rowHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX, currentY = bounds.minY, rowHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX, currentX > bounds.minX {
                currentX = bounds.minX; currentY += rowHeight + spacing; rowHeight = 0
            }
            view.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview("Digimon Detail") {
    DigimonDetailView(
        digimonId: 1,
        name: "Agumon",
        service: MockDigimonService()   // ✅ no network, no decode errors
    )
}
