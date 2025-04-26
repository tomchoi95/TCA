//
//  NumberFactClient.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-26.
//

import Foundation
import ComposableArchitecture

// 구조체로 의존성을 정의 할 것임. 프로토콜로 하지 않을거다.
// 그리고 이는 fetch를 가지고 있고, 그것은 클로져 혹은 함수를 갖는다.
// 이거 마치 프로토콜같다. 프로토콜의 기능을 한다.
// 그런데 장점이 뭘까?
/*
 프로토콜 대신 구조체를 사용하는 것의 주요 장점들을 설명해드리겠습니다:
 간단성과 직관성
 프로토콜은 구현해야 할 메서드들을 정의하고, 이를 채택하는 타입들이 각각 구현해야 하는 복잡한 구조를 가집니다.
 구조체는 단순히 함수를 프로퍼티로 가지는 형태로, 더 직관적이고 이해하기 쉽습니다.
 유연성
 구조체를 사용하면 런타임에 함수를 쉽게 교체할 수 있습니다.
 프로토콜은 컴파일 타임에 고정된 구현을 요구하지만, 구조체는 동적으로 함수를 주입할 수 있습니다.
 테스트 용이성
 테스트 시에 실제 네트워크 호출 대신 목(mock) 함수를 쉽게 주입할 수 있습니다.
 프로토콜을 사용할 경우, 매번 새로운 타입을 만들어서 프로토콜을 채택해야 하지만, 구조체는 단순히 함수만 교체하면 됩니다.
 의존성 주입의 단순화
 구조체를 사용하면 의존성 주입이 더 단순해집니다.
 프로토콜을 사용할 경우, 의존성 주입을 위한 추가적인 보일러플레이트 코드가 필요할 수 있습니다.
 성능
 프로토콜은 동적 디스패치를 사용하지만, 구조체는 정적 디스패치를 사용할 수 있어 더 나은 성능을 보일 수 있습니다.
 예를 들어, 테스트 코드에서는 이렇게 간단하게 목(mock) 함수를 주입할 수 있습니다:
 */

struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

// 의존성 래퍼로 사용할 키값 만들기.
extension NumberFactClient: DependencyKey {
    // 실 사용시 구현될 로직. 위에서 만든 프로토콜? 같은 구조체 구현을 여기서 직접 하게 됨.
    static let liveValue: NumberFactClient = .init(
        fetch: { number in
            let request = URLRequest(url: URL(string: "http://numbersapi.com/\(number)")!)
            let (data, _) = try await URLSession.shared.data(for: request)
            return String(decoding: data, as: UTF8.self)
        }
    )
    
    static let testValue: NumberFactClient = .init(
        fetch: { $0.description }
    )
}

// Dependency에 벨류를 추가하기.
extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}


/**
 Section 4
 
 Controlling dependencies
 의존성 제어
 Now we see the problem with using uncontrolled dependencies in our feature code.
 이제 우리는 우리의 기능 코드에서 제어되지 않은 의존성을 사용하는 것이 어떤 문제를 일으키는지 알게 되었습니다.
 It makes our code hard to test, and can make tests take a long time to run or become flakey.
 이는 우리의 코드를 테스트하기 어렵게 만들고, 테스트 실행에 오랜 시간이 걸리거나 불안정하게 만들 수 있습니다.
 For these reasons, and more, it is highly encouraged for you to control your dependency on external systems (see Dependencies for more information).
 이러한 이유들, 그리고 그 이상의 이유들로 인해 외부 시스템에 대한 의존성을 제어하는 것이 강력히 권장됩니다 (더 자세한 내용은 의존성 문서를 참고하십시오).
 The Composable Architecture comes with a complete set of tools for controlling and propagating dependencies throughout an application.
 Composable Architecture는 애플리케이션 전체에 걸쳐 의존성을 제어하고 전파하기 위한 완벽한 도구 세트를 제공합니다.
 
 Step 1
 Start by creating a new file, NumberFactClient.swift, and import the Composable Architecture. This will give you access to the tools necessary to control any dependency in your feature.
 새로운 파일 NumberFactClient.swift를 생성하고 Composable Architecture를 임포트하는 것으로 시작하십시오. 이를 통해 당신의 기능에서 어떤 의존성이든 제어하는 데 필요한 도구에 접근할 수 있게 될 것입니다.
 
 Step 2
 The first step to controlling your dependency is to model an interface that abstracts the dependency, in this case a single async, throwing endpoint that takes an integer and returns a string.
 의존성을 제어하기 위한 첫 번째 단계는 해당 의존성(이 경우, 정수를 받아들이고 문자열을 반환하는 단일 비동기, 오류 발생 가능 엔드포인트)을 추상화하는 인터페이스를 모델링하는 것입니다.
 This will allow you to use a “live” version of the dependency when running your feature in simulators and devices, but you can use a more controlled version during tests.
 이는 당신이 시뮬레이터와 장치에서 당신의 기능을 실행할 때 해당 의존성의 "실제" 버전을 사용하도록 해줄 것이며, 테스트 중에는 더 제어된 버전을 사용할 수 있습니다.
 
 Tip
 While protocols are by far the most popular way of abstracting dependency interfaces, they are not the only way.
 의존성 인터페이스를 추상화하는 데 프로토콜이 단연코 가장 보편적인 방식이지만, 그것이 유일한 방법은 아닙니다.
 We prefer to use structs with mutable properties to represent the interface, and then construct values of the struct to represent conformances.
 우리는 해당 인터페이스를 나타내기 위해 가변 프로퍼티를 가진 스트럭트(struct)를 사용하는 것을 선호하며, 그런 다음 적합성(conformances)을 나타내기 위해 그 스트럭트의 값을 생성합니다.
 You can use protocols for your dependencies if you so wish, but if you are interested in learning more about the struct style, see our series of videos for more information.
 만약 당신이 원한다면 당신의 의존성을 위해 프로토콜을 사용할 수 있지만, 만약 당신이 스트럭트 스타일에 대해 더 배우는 데 관심이 있다면, 더 자세한 내용은 우리의 비디오 시리즈를 참고하십시오.
 
 Step 3
 Next you need to register your dependency with the library, which requires two steps.
 다음으로 당신은 해당 라이브러리에 당신의 의존성을 등록해야 하는데, 이는 두 단계를 필요로 합니다.
 First you conform the client to the DependencyKey protocol, which requires you to provide a liveValue.
 첫 번째로 당신은 클라이언트를 DependencyKey 프로토콜에 적합시키는데, 이는 당신에게 liveValue를 제공할 것을 요구합니다.
 This is the value used when your feature is run in simulators and devices, and it’s the place where it is appropriate to make live network requests.
 이것은 시뮬레이터와 장치에서 당신의 기능이 실행될 때 사용되는 값이며, 실제 네트워크 요청을 하기에 적절한 장소입니다.
 
 Note
 Technically the dependency management system in the Composable Architecture is provided by another library of ours, swift-dependencies.
 기술적으로는 Composable Architecture 내의 의존성 관리 시스템은 우리의 또 다른 라이브러리인 swift-dependencies에 의해 제공됩니다.
 We split that library out of the Composable Architecture once it became clear that it could be useful even in vanilla SwiftUI and UIKit applications.
 우리는 그것이 바닐라 SwiftUI 및 UIKit 애플리케이션에서조차 유용할 수 있다는 점이 명확해지자마자 그 라이브러리를 Composable Architecture에서 분리했습니다.
 
 Step 4
 The second step to registering the dependency with the library is to add a computed property to DependencyValues with a getter and a setter.
 해당 라이브러리에 의존성을 등록하는 두 번째 단계는 getter와 setter를 가진 연산 프로퍼티를 DependencyValues에 추가하는 것입니다.
 This is what allows for the syntax @Dependency(\.numberFact) in the reducer.
 이것이 리듀서(reducer)에서 @Dependency(.numberFact) 구문(syntax)을 가능하게 하는 것입니다.
 
 Note
 Registering a dependency with the library is not unlike registering an environment value with SwiftUI, which requires conforming to EnvironmentKey to provide a defaultValue value and extending EnvironmentValues to provide a computed property.
 라이브러리에 의존성을 등록하는 것은 SwiftUI에 환경 값을 등록하는 것과 다르지 않으며, 이는 EnvironmentKey에 적합(conforming)하여 defaultValue 값을 제공하고 EnvironmentValues를 확장하여 연산 프로퍼티(computed property)를 제공해야 합니다.
 That is all it takes to put a controllable interface in front your dependency.
 당신의 의존성 앞에 제어 가능한 인터페이스를 두는 데 필요한 전부입니다.
 With that little bit of upfront work you can start using the dependency in your features, and most importantly, start using test-friendly versions of the dependency in tests.
 그 약간의 사전 작업으로 당신은 당신의 기능들에서 해당 의존성을 사용하기 시작할 수 있으며, 그리고 가장 중요하게는 테스트에서 해당 의존성의 테스트 친화적인 버전을 사용하기 시작할 수 있습니다.
 
 Step 5
 Go back to CounterFeature.swift and add a new dependency using the @Dependency property wrapper, but this time for the number fact client.
 CounterFeature.swift로 돌아가서 @Dependency 프로퍼티 래퍼를 사용하여 새로운 의존성을 추가하십시오. 하지만 이번에는 숫자 팩트 클라이언트를 위한 것입니다.
 Then, in the effect returned from factButtonTapped, use the numberFact dependency to load the fact rather than reaching out to URLSession to make a live network request.
 그런 다음, factButtonTapped에서 반환된 이펙트(effect)에서 numberFact 의존성을 사용하여 팩트(fact)를 로드하십시오. 이는 실제 네트워크 요청을 위해 URLSession에 직접 접근하는 대신입니다.
 */
