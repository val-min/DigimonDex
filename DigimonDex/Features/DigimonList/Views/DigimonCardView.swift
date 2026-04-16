//
//  DigimonCardView.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct DigimonCardView: View {
    let item: DigimonListItem
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.digiDark, Color.digiBlue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.digiBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // Digimon image
            WebImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ZStack {
                    Color.white.opacity(0.05)
                    Image(systemName: "photo.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.white.opacity(0.3))
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 12)
            .padding(.bottom, 40)
            
            // Name banner
            VStack(spacing: 0) {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(height: 44)
                    
                    Text(item.name)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 6)
            }
            
            // ID badge
            VStack {
                HStack {
                    Spacer()
                    Text("#\(item.id)")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                        .padding(8)
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .aspectRatio(0.75, contentMode: .fit)
    }
}

#Preview {
    let mockItem = DigimonListItem(
        id: 1,
        name: "Agumon",
        href: "https://digi-api.com/api/v1/digimon/1",
        image: "https://digimon-api.vercel.app/images/digimon/agumon.png"
    )
    
    return DigimonCardView(item: mockItem)
        .frame(width: 180, height: 240)
        .padding()
        .background(Color.digiDark)
}

