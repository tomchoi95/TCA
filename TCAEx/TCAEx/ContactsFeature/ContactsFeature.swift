//
//  ContactsFeature.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-26.
//

import Foundation
import ComposableArchitecture

struct Contact: Identifiable, Equatable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        // 아래의 addContact의 상태가 주입되면 preesent될 것임.
        @Presents var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .addButtonTapped:
                    // 이제 액션을 추가할 것인데, 이 액션은 위의 add Contact 상태의 옵셔널을 해제하기 만듦
                    state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))
                    return .none
                    
                    
                case .addContact(.presented(.delegate(.save(let contect)))):
                    state.contacts.append(contect)
                    return .none
                    
                case .addContact:
                    // TODO: handle event
                    return .none
            }
        }
        // ifLet 이거 냄새가 옵셔널 까는데 쓰는냄새가 남. 즉, 위에서 프레젠테이션 상태가 옵셔널임. 이게 옵셔널이 해제될 때 작동할것임.
        // 그리고 이건 AddContactFeature 리듀셔를 리턴함.
        // 아래는 addContact가 nill이 아닐 경우 그 상태와. action을 가지는 AddContactFeture Reducer 생성.
        .ifLet(\.$addContact, action: \.addContact) { AddContactFeature() }
    }
}
