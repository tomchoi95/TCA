//
//  CounterFeature.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-10.
//

import ComposableArchitecture

// 아래의 Reducer 매크로가 Reducer프로토콜을 채택 + etc의 역할
// 매크로에() 를 하면 @Reducer(state: <#T##_SynthesizedConformance...##_SynthesizedConformance#>, action: <#T##_SynthesizedConformance...##_SynthesizedConformance#>) 이렇게 됨.
// 여기서 state와 action에게 codable, decodable, encodable, equatable, hashable, sendable을 채택할 수 있게 함.

@Reducer
struct CounterFeature {
    /**
     To conform to Reducer you will start with a domain modeling exercise. You will create a State type that holds the state your feature needs to do its job, typically a struct. Then you will create an Action type that holds all the actions the user can perform in the feature, typically an enum.
     */
    /**
     Further, if your feature is to be observed by SwiftUI, which is usually the case, you must annotate its state with the ObservableState() macro. It is the Composable Architecture’s version of @Observable, but tuned to value types.
     */
    // 위에서 말했듯. SwiftUI에서 @Observable매크로가 있듯이, TCA에서는 @ObservableState가 있다.
    // 이름에서부터 알 수 있듯이 상태에 매크로를 달아준다. 그런데,'tuned to value types'
    @ObservableState
    struct State {
        /**
         For the purpose of a simple counter feature, the state consists of just a single integer, the current count, and the actions consist of tapping buttons to either increment or decrement the count.
         */
        var count = 0
    }
    
    enum Action {
        /**
         Tip
         It is best to name the Action cases after literally what the user does in the UI, such as incrementButtonTapped, rather than what logic you want to perform, such as incrementCount.
         */
        // 변수의 이름을 지어줄 때, UI 이벤트 위주로, 수동적인 느낌알쥬?
        case incrementButtonTapped
        case decrementButtonTapped
    }
    /**
     Step 5
     And finally, to finish conforming to Reducer, you must implement a body property with a Reduce reducer that evolves the state from its current value to the next value given a user action, and returns any effects that the feature wants to execute in the outside world. This almost always begins by switching on the incoming action to determine what logic you need to perform, and the state is provided as inout so you can perform mutations on it directly.
     Note
     A reducer is implemented by providing a body property, and then listing the reducers inside that you want to compose. Right now we only have one reducer we want to run, and so a simple Reduce is sufficient, but it is more typical to compose many reducers together, and that will be shown later in the tutorial.
     */
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .decrementButtonTapped:
                    state.count -= 1
                    return .none
                case .incrementButtonTapped:
                    state.count += 1
                    return .none
            }
        }
    }
}

