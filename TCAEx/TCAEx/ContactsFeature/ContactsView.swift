//
//  ContactView.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-26.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        List(store.contacts) { contact in
            HStack {
                Text(contact.name)
                Spacer()
                Button {
                    store.send(.deleteButtonTapped(id: contact.id))
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Contacts")
        .toolbar { Button(action: { store.send(.addButtonTapped) }, label: { Image(systemName: "plus") }) }
        .sheet(
            // 여기서 item이 nil이면 sheet가 닫히고, nill이 아니게 되면, sheet가 열림.
            item: $store.scope(state: \.addContact, action: \.addContact),
            //            그리고 그 열리는 sheet는 { store in AddContactView(store: store) }라는 closure로 구성됨.
            //            또한 그 클로저의 파라메터는 위에서 알 수 있듯이. scope로, state는 addContact, action은 addContact인 store가 됨.
            content: { store in NavigationStack { AddContactView(store: store) } }
        )
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    ContactsView(
        store: Store(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: UUID(), name: "Blob"),
                    Contact(id: UUID(), name: "Blob Jr"),
                    Contact(id: UUID(), name: "Blob Sr"),
                ]
            )
        ) {
            ContactsFeature()
        }
    )
}
