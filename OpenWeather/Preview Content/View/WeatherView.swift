//
//  ContentView.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @ViewBuilder func progressView() -> some View {
        ProgressView("Loading...")
    }
    
    @ViewBuilder private func renderErrorView() -> some View {
        
        Text(viewModel.errorMessage)
            .foregroundColor(.red)
            .padding()

    }
    
    @ViewBuilder private func renderButtonView() -> some View {
        
        Button(action: {
            
            Task {
                await viewModel.fetchWeatherForCurrentLocation()
            }
            
        }) {
            Text("Get Weather for your city")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    @ViewBuilder private func renderPortraitView(withWeather weather: Weather) -> some View {

        VStack {
            WeatherDetailsView(weather: weather)
            WeatherIconView(weather: weather)
        }
        
    }
    
    @ViewBuilder private func renderLandscapeView(withWeather weather: Weather) -> some View {

        HStack {
            WeatherDetailsView(weather: weather)
            WeatherIconView(weather: weather)
        }
        
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                
                if viewModel.isLoading {
                    progressView()
                } else if let weather = viewModel.weather {
                    Text("City: \(weather.name)")
                        .font(.largeTitle)
                        .padding()
                    
                    if horizontalSizeClass == .compact {
                        
                        renderPortraitView(withWeather: weather)
                        
                    } else {
                        renderLandscapeView(withWeather: weather)
                    }
                    
                } else {
                    renderErrorView()
                }
                
                renderButtonView()
            }.task {
                if !viewModel.isPermissionDenied {
                    viewModel.checkLocationAuthorization()
                }
            }
            .searchable(text: <#T##Binding<String>#>)
            .padding()
        }
    }
}

#Preview {
    WeatherView()
}
