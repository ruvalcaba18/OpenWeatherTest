//
//  ContentView.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject var viewModel: WeatherViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    init(weatherManager: WeatherManager = WeatherManager(), locationManager: LocationManager = LocationManager()) {
        
        _viewModel = StateObject(wrappedValue: WeatherViewModel(weatherManager: weatherManager, locationManager: locationManager))
        
    }
    
    
    
    @ViewBuilder func progressView() -> some View {
        
        ProgressView("Loading...")
    }
    
    @ViewBuilder private func renderErrorView() -> some View {
        VStack{
            Image("friendly_error")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text(viewModel.errorMessage ?? "" )
                .foregroundColor(.red)
                .padding()
        }
    }
    
    @ViewBuilder private func renderButtonView() -> some View {
        
        Button(action: {
            
            Task {
                await viewModel.fetchWeatherForCurrentLocation()
            }
            
        },label: {
            
            Text("Get Weather for your city")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            
        })
    }
    
    @ViewBuilder private func renderPortraitView(withWeather weather: Weather) -> some View {
        
        VStack {
            
            WeatherDetailsView(weather: weather)
            
            WeatherIconView(weatherData: weather, viewModel: viewModel)
        }
    }
    
    @ViewBuilder private func renderLandscapeView(withWeather weather: Weather) -> some View {
        
        HStack {
            
            WeatherDetailsView(weather: weather)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            WeatherIconView(weatherData: weather, viewModel: viewModel)
                .frame(width: 200, height: 200)
                .padding()
        }
        .padding()
    }
    
    var body: some View {
        
        NavigationView {
            
            ScrollView{
                
                VStack(spacing: 0) {
                    
                    if viewModel.isLoading {
                        
                        progressView()
                            .accessibilityIdentifier("weatherProgressView")
                        
                    } else if let weather = viewModel.weather {
                        
                        Text("City: \(weather.name)")
                            .font(.largeTitle)
                            .padding()
                            .accessibilityIdentifier("cityTitleView")
                        
                        if horizontalSizeClass == .compact {
                            renderPortraitView(withWeather: weather)
                        } else {
                            renderLandscapeView(withWeather: weather)
                        }
                        
                    } else if viewModel.errorMessage != nil{
                        
                        renderErrorView()
                            .accessibilityIdentifier("errorMessageView")
                    }
                    
                    renderButtonView()
                        .accessibilityIdentifier("fetchWeatherButton")
                }
                .searchable(text: $viewModel.searchQuery, prompt: "Search for a city")
                .task {
                    if !viewModel.isPermissionDenied {
                        viewModel.checkLocationPermission()
                    }
                }
                .padding()
            }
            .accessibilityIdentifier("weatherScrollView")
        }
    }
}

#Preview {
    WeatherView()
}
