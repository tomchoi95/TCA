//
//  AddContactFeature.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-26.
//

import ComposableArchitecture

@Reducer
struct AddContactFeature {
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case saveButtonTapped
        case cancelButtonTapped
        case textFieldChanged(String)
        case delegate(Delegate)
        enum Delegate {
            case save(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .cancelButtonTapped:
                    return .run { _ in await dismiss() }
                    
                case .saveButtonTapped:
                    return .run { [contact = state.contact] send in
                        await send(.delegate(.save(contact)))
                        await dismiss()
                    }
                    
                case .textFieldChanged(let name):
                    state.contact.name = name
                    return .none
                    
                case .delegate:
                    return .none
            }
        }
    }
}

