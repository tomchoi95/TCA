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
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            Tab("Counter 1", systemImage: "1.circle.fill") {
                CounterView(store: store.scope(state: \.tab1, action: \.tab1))
            }
            Tab("Counter 1", systemImage: "2.circle.fill") {
                CounterView(store: store.scope(state: \.tab2, action: \.tab2))
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

