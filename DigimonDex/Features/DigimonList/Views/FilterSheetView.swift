//
//  FilterSheetView.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import SwiftUI

struct FilterSheetView: View {
    @Binding var filter: FilterOptions
    @Environment(\.dismiss) private var dismiss
    
    @State private var localFilter: FilterOptions
    
    init(filter: Binding<FilterOptions>) {
        self._filter = filter
        self._localFilter = State(initialValue: filter.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Search by name") {
                    TextField("e.g. Agumon", text: $localFilter.name)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                Section("Level") {
                    Picker("Level", selection: $localFilter.level) {
                        Text("Any").tag("")
                        ForEach(FilterMeta.levels, id: \.self) { lvl in
                            Text(lvl).tag(lvl)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Attribute") {
                    Picker("Attribute", selection: $localFilter.attribute) {
                        Text("Any").tag("")
                        ForEach(FilterMeta.attributes, id: \.self) { attr in
                            Text(attr).tag(attr)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Type") {
                    Picker("Type", selection: $localFilter.type_) {
                        Text("Any").tag("")
                        ForEach(FilterMeta.types, id: \.self) { t in
                            Text(t).tag(t)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Button(role: .destructive) {
                        localFilter.reset()
                    } label: {
                        Label("Reset Filters", systemImage: "xmark.circle.fill")
                    }
                }
            }
            .navigationTitle("Filter Digimon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        filter = localFilter
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    FilterSheetView(filter: .constant(FilterOptions()))
}
