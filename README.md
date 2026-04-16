# DigiDex 📱

A Digimon encyclopedia iOS app built with SwiftUI, powered by [digi-api.com](https://digi-api.com).

## Features
- 🔍 Search Digimon by name
- 🎛️ Filter by Attribute and Level
- 📜 Infinite scroll — 8 cards per page
- 🃏 Card details with images, skills, fields, and evolution chains
- ⚠️ Error handling for no internet / API errors

## Tech Stack
- Swift 6 / SwiftUI
- MVVM architecture
- async/await + Combine
- Two-level image cache (NSCache + disk)

## API
Uses the free [Digi-API](https://digi-api.com) — no API key required.

## Requirements
- Xcode 15+
- iOS 16+
