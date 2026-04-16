//
//  Color+Extension.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import SwiftUI

extension Color {
    static let digiBlue   = Color(red: 0.15, green: 0.47, blue: 0.85)
    static let digiOrange = Color(red: 0.95, green: 0.55, blue: 0.15)
    static let digiDark   = Color(red: 0.07, green: 0.09, blue: 0.14)
    
    static func levelColor(_ level: String) -> Color {
        switch level.lowercased() {
        case "mega":       return .purple
        case "ultimate":   return .red
        case "champion":   return .orange
        case "rookie":     return .green
        case "in-training":return .blue
        case "fresh":      return .cyan
        default:           return .gray
        }
    }
}
