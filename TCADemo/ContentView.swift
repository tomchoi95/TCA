//
//  ContentView.swift
//  TCADemo
//
//  Created by 최범수 on 2025-04-24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        VStack {
            Text(store.count.description)
                .padding()
                .font(.largeTitle)
                .background(Color.gray.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            HStack {
                Button("-") { store.send(.decrementButtonTapped) }
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .background(Color.gray.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Button("+") { store.send(.incrementButtonTapped) }
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .background(Color.gray.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(
        store: Store(initialState: CounterFeature.State(), reducer: {
            CounterFeature()
                ._printChanges()
        })
    )
}
