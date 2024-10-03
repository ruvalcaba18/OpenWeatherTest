//
//  ContentView.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import SwiftUI

struct WeatherView: View {
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

#Preview {
    WeatherView()
}
