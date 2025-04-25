//
//  ContentView.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-09.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                
            HStack {
                Button("-") { store.send(.decrementButtonTapped) }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") { store.send(.incrementButtonTapped) }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            
            Button("Fact") { store.send(.factButtonTapped) }
                  .font(.largeTitle)
                  .padding()
                  .background(Color.black.opacity(0.1))
                  .cornerRadius(10)
            Group {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text(store.fact ?? "")
                }
            }
            .frame(height: 50)
            .padding()
        }
        .padding()
    }
}

#Preview {
    let store: Store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    CounterView(store: store)
}
