//
//  AppFeature.swift .swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-26.
//

/**
 Essentials
 Composing features
 Learn what makes the Composable Architecture… well… “composable”. We will create a parent feature that contains the CounterFeature we have been building thus far.
 */
import Foundation
import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store1: StoreOf<CounterFeature>
    let store2: StoreOf<CounterFeature>
    
    var body: some View {
        TabView {
            Tab("Counter 1", systemImage: "1.circle.fill") {
                CounterView(store: store1)
            }
            Tab("Counter 1", systemImage: "2.circle.fill") {
                CounterView(store: store2)
                Text("d")
            }
        }
    }
}


/**
 **Adding a tab view**
 탭 뷰 추가하기

 **We will explore composing features together by adding a TabView feature with two tabs, each housing a CounterFeature.**
 두 개의 탭을 가진 TabView 기능을 추가하면서, 각각의 탭에 CounterFeature를 넣어 기능을 조합하는 방법을 알아볼 것입니다.
 **This will give us the opportunity to explore the Scope reducer and the scope operator on stores.**
 이를 통해 Scope reducer와 store에 대한 scope 연산자에 대해 살펴볼 기회를 가질 수 있습니다.
 **Let’s approach this in a naive way first by trying to create a root level view that uses a TabView.**
 먼저 단순한 방식으로 접근해, TabView를 사용하는 루트 레벨 뷰를 만들어보겠습니다.
 **To keep things simple we will just have two tabs, and each will contain their own isolated CounterView, which was built previously in the tutorial.**
 간단하게 하기 위해 두 개의 탭만 만들고, 각 탭에는 이전 튜토리얼에서 만든 독립적인 CounterView를 넣겠습니다.

 ---

 **Step 1**
 1단계

 **Create a new file called AppFeature.swift with some basic scaffolding in place already for a tab-based view.**
 탭 기반 뷰를 위한 기본 구조가 있는 `AppFeature.swift`라는 새 파일을 만드세요.

 ---

 **Step 2**
 2단계

 **In the tab view we want to create two CounterViews, one for each tab, but in order to do so we need to supply two stores.**
 탭 뷰에는 각 탭마다 하나씩, 두 개의 CounterView를 넣을 것이며, 그렇게 하기 위해서는 두 개의 store가 필요합니다.
 **Where do we get these stores from?**
 그렇다면 이 store들은 어디서 가져올까요?
 **Previously when building the CounterView the store was defined as a simple let property and then whoever constructed the CounterView (e.g. the SwiftUI preview and app entry point) was responsible for constructing the store and passing it along.**
 이전에 CounterView를 만들 때는 store를 단순한 `let` 프로퍼티로 정의했고, 해당 CounterView를 만드는 쪽(SwiftUI 프리뷰나 앱 진입점)이 store를 생성해서 전달해 주는 식이었습니다.
 **We could try that same strategy here.**
 여기서도 같은 전략을 시도해볼 수 있습니다.

 ---

 **Step 3**
 3단계

 **Add two new variables to AppView that hold stores to be provided to each CounterView.**
 `AppView`에 두 개의 store를 담는 새 변수를 추가하고, 이를 각각의 CounterView에 전달하도록 합니다.
 **However, this is not ideal.**
 하지만 이 방식은 이상적이지 않습니다.
 **We now have two completely isolated stores that are not capable of communicating with each other.**
 이제 서로 통신할 수 없는 완전히 분리된 두 개의 store가 생겼기 때문입니다.
 **In the future there may be events that happen in one tab that can affect the other tab.**
 앞으로 한 탭에서 발생한 이벤트가 다른 탭에 영향을 주는 상황이 생길 수도 있습니다.
 **This is why in the Composable Architecture we prefer to compose features together and have our views powered by a single Store, rather than have multiple isolated stores.**
 이런 이유로 Composable Architecture에서는 여러 개의 독립된 store를 사용하는 대신, 하나의 store로 여러 기능을 함께 구성하는 방식을 선호합니다.
 **This makes it extremely easy for features to communicate with each other, and we can even write tests that the communication is working properly.**
 이렇게 하면 기능 간의 통신이 매우 쉬워지고, 그 통신이 제대로 이루어지는지 테스트도 작성할 수 있게 됩니다.
 **So, let’s put the view aside for a moment and focus first on composing our features’ reducers together into a single package, and then we will come back to the view and see how to properly create this tab view.**
 따라서 지금은 뷰는 잠시 제쳐두고, 먼저 여러 기능의 reducer를 하나로 구성하는 데 집중한 다음, 그 후에 이 tab view를 제대로 만드는 방법을 다시 살펴보겠습니다.
 */

/**
 Section 2
 섹션 2

 Composing reducers
 리듀서 구성하기

 We’ve now seen that by approaching the problem of composing features naively we run into a weird situation of having multiple isolated stores.
 이제 기능 조합 문제를 단순하게 접근하면 여러 개의 고립된 store가 생기는 이상한 상황이 발생하는 것을 보았습니다.

 We can fix this problem by first composing the features together at the reducer level, and then showing how we can have a single store power our tab-based application.
 이 문제는 먼저 reducer 레벨에서 기능을 조합하고, 그 다음 하나의 store로 탭 기반 애플리케이션을 구동하는 방법을 보여줌으로써 해결할 수 있습니다.

 We are going to create a new app-level reducer to power the logic and behavior of the AppView we created above.
 앞에서 만든 AppView의 로직과 동작을 담당할 새로운 앱 수준의 리듀서를 만들 것입니다.

 We will also be putting the reducer in the same file as the view, just as we did for CounterFeature and CounterView.
 CounterFeature와 CounterView에서 했던 것처럼, reducer를 view와 같은 파일에 넣을 것입니다.

 We personally prefer to do this until our features get too big, and then we will split the reducer and view into their own files.
 개인적으로는 기능이 너무 커지기 전까지 이렇게 작성하고, 이후에 reducer와 view를 별도 파일로 분리하는 것을 선호합니다.

 Step 1
 1단계

 Create a new AppFeature struct and apply the Reducer() macro.
 새로운 AppFeature 구조체를 만들고 @Reducer 매크로를 적용하세요.

 Step 2
 2단계

 Add a State struct and Action enum to the reducer.
 리듀서에 State 구조체와 Action 열거형을 추가하세요.

 These data types will hold the state and actions for each tab, each of which are just the CounterFeature.
 이 데이터 타입들은 각각의 탭 상태와 액션을 보유하게 되며, 각각은 단순히 CounterFeature를 나타냅니다.

 Note
 참고

 We are proactively conforming State to Equatable in order to be able to write tests on this feature later.
 나중에 이 기능에 대한 테스트를 작성할 수 있도록 State를 Equatable에 미리 준수하도록 합니다.

 Step 3
 3단계

 Next we need to implement the body of the reducer.
 다음으로는 reducer의 body를 구현해야 합니다.

 Previously we did this by using the Reduce type to open a closure and perform any state mutations necessary based on the action passed in.
 이전에 우리는 Reduce 타입을 사용하여 클로저를 열고, 전달된 액션에 따라 필요한 상태 변경을 수행했습니다.

 We still want to do that for the core logic of the app feature, but we also want compose in the CounterFeature reducer so that its logic can execute on the tab1 and tab2 state without the AppFeature having to recreate it.
 이번에도 앱 기능의 핵심 로직을 위해 이 방법을 사용할 것이지만, 동시에 CounterFeature의 리듀서도 조합하여 AppFeature가 직접 그 로직을 다시 작성하지 않고도 tab1과 tab2 상태에서 실행할 수 있게 하려 합니다.

 Step 4
 4단계

 To compose the CounterFeature into the AppFeature we can use the Scope reducer.
 CounterFeature를 AppFeature에 조합하기 위해 Scope 리듀서를 사용할 수 있습니다.

 It allows you to focus in on a sub-domain of the parent feature, and run a child reducer on that sub-domain.
 Scope는 부모 기능의 하위 도메인에 집중하고, 해당 하위 도메인에서 자식 리듀서를 실행할 수 있도록 해줍니다.

 In this case we want to do that twice.
 이번 경우에는 이를 두 번 사용해야 합니다.

 First we single out the tab1 state and actions in order to run the CounterFeature reducer, and then we do it again for the tab2 state and actions.
 먼저 tab1의 상태와 액션을 분리해서 CounterFeature 리듀서를 실행하고, 그런 다음 tab2의 상태와 액션에 대해서도 똑같이 합니다.

 Note
 참고

 The body computed property is using result builders behind the scenes.
 body 계산 프로퍼티는 내부적으로 result builders를 사용합니다.

 It allows us to list any number of reducers in the body as long as the types match up.
 타입이 일치하는 한 body 안에 여러 개의 리듀서를 나열할 수 있게 해줍니다.

 When an action comes into the system each reducer will run on the feature’s state from top-to-bottom.
 액션이 시스템에 들어오면 각 리듀서가 순서대로 feature의 상태에 대해 실행됩니다.

 Result builders is also what SwiftUI uses to compose view hierarchies in a view body.
 result builders는 SwiftUI가 view body 안에서 뷰 계층을 구성할 때도 사용하는 기술입니다.

 The AppFeature is now a fully composed feature comprising 3 completely independent features:
 이제 AppFeature는 세 가지 완전히 독립적인 기능을 조합한 완성된 기능이 되었습니다:

 there’s the core app feature logic, the counter feature running in the first tab, and the counter feature running in the second tab.
 핵심 앱 기능 로직, 첫 번째 탭에서 실행되는 카운터 기능, 두 번째 탭에서 실행되는 카운터 기능이 있습니다.

 We can even write a test for this integration of features before even getting the view properly working.
 심지어 뷰를 제대로 작동시키기 전에 이 기능 통합에 대한 테스트를 작성할 수도 있습니다.

 Step 5
 5단계

 Create a new file in your test target called AppFeatureTests.swift and paste in the following basic scaffolding.
 테스트 타겟에 AppFeatureTests.swift라는 새 파일을 만들고 다음의 기본 구조를 붙여넣으세요.

 We are going to start by showing that when the increment button is tapped in the first tab, the count goes up in the tab1 state.
 먼저 첫 번째 탭에서 증가 버튼을 탭했을 때, tab1의 상태에서 count가 증가하는 것을 보여줄 것입니다.

 Step 6
 6단계

 Create a TestStore that holds onto the AppFeature domain.
 AppFeature 도메인을 보유하는 TestStore를 만드세요.

 This is done by providing the initial state of the feature and specifying the reducer that powers the feature.
 초기 상태를 제공하고, 기능을 구동하는 리듀서를 지정함으로써 이 작업을 수행합니다.

 Note
 참고

 Remember that the TestStore is the testable runtime of a feature that allows you to send actions and assert on how state changes.
 TestStore는 액션을 보내고 상태 변화에 대해 검증(assert)할 수 있게 해주는 기능의 테스트 가능한 런타임입니다.

 It also forces you to assert on how effects emit data back into the system.
 또한 효과(effects)가 시스템에 데이터를 다시 전달할 때 그 동작을 검증하도록 강제합니다.

 Step 7
 7단계

 Send an action into the test store to emulate the user tapping on the increment button in the first tab.
 첫 번째 탭에서 사용자가 증가 버튼을 탭하는 것을 시뮬레이션하기 위해, 액션을 테스트 스토어로 보내세요.

 Tip
 팁

 Use case key path syntax when sending actions through multiple layers of features.
 여러 계층의 기능을 통과할 때 액션을 보낼 때는 key path 문법을 사용하세요.

 Note
 참고

 The nesting of the action enums of the features gives us a natural way to distinguish between actions in different tabs.
 기능의 액션 열거형이 중첩되어 있기 때문에, 서로 다른 탭의 액션을 자연스럽게 구분할 수 있습니다.

 Sending .tab1.incrementButtonTapped is very different from sending .tab2.incrementButtonTapped.
 \.tab1.incrementButtonTapped를 보내는 것과 \.tab2.incrementButtonTapped를 보내는 것은 완전히 다른 동작입니다.

 If we were to run this test it would of course fail because we have not asserted on how state changes after sending this action, and by default the TestStore requires that you exhaustively assert on everything happening in the feature.
 이 테스트를 지금 실행하면 당연히 실패할 것입니다. 왜냐하면 액션을 보낸 후 상태 변화에 대한 검증을 아직 작성하지 않았기 때문입니다. TestStore는 기본적으로 기능 내에서 일어나는 모든 변화에 대해 철저히 검증하도록 요구합니다.

 Step 8
 8단계

 To get the test to pass we have to open up a trailing closure on store.send and mutate the previous version of the feature state so that it matches the state after the action is sent.
 테스트를 통과시키려면 store.send 뒤에 클로저를 열고, 액션이 전달된 후의 상태와 일치하도록 기존 feature 상태를 변경해야 합니다.

 And now this test passes!
 이제 테스트가 통과합니다!
 */
