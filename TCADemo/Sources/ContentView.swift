import SwiftUI
import ComposableArchitecture

public struct ContentView: View {
    private let store: StoreOf<CounterFeature>
    
    public init(store: StoreOf<CounterFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text(store.state.count.description)
            .bold()
            .font(.largeTitle)
            .padding()
        HStack {
            Button("-") { store.send(.decrementButtonDidTap) }
                .font(.largeTitle)
                .padding(.horizontal)
                .background(Color.gray.secondary)
                .clipShape(.buttonBorder)
            Button("+") { store.send(.incrementButtonDidTap) }
                .font(.largeTitle)
                .padding(.horizontal)
                .background(Color.gray.secondary)
                .clipShape(.buttonBorder)
        }
        Button(store.timmerIsRunning ? "Stop Timer" : "Start Timer") { store.send(.timmerToggleButtonDidTap) }
            .padding()
            .background(Color.gray.secondary)
            .clipShape(.buttonBorder)
        Button("fetch") { store.send(.fetchButtonDidTap) }
            .padding()
            .background(Color.gray.secondary)
            .clipShape(.buttonBorder)
        Group {
            if store.state.isLoading {
                ProgressView()
            } else {
                Text(store.state.text)
            }
        }
        .frame(height: 50)
        .padding()
    }
}

#Preview {
    ContentView(store: Store(initialState: CounterFeature.State(), reducer: {
        CounterFeature()
            .signpost()
    }))
}
