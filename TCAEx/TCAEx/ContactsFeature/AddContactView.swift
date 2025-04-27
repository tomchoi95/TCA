//
//  AddContactView.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-26.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form {
            TextField("Name", text: $store.contact.name.sending(\.textFieldChanged))
            Button("Save", action: { store.send(.saveButtonTapped)})
        }
        .toolbar {
            ToolbarItem(content: { Button("Cancel") { store.send(.cancelButtonTapped)} })
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(
            store: Store(
                initialState: AddContactFeature.State(contact: Contact(id: UUID(), name: "Blob")),
                reducer: { AddContactFeature()._printChanges() }
            )
        )
    }
}
