//
//  WeatherIconView.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import SwiftUI

struct WeatherIconView: View {
    
    let weatherData: Weather
    @State private var weatherImage: UIImage? = nil
    @ObservedObject var viewModel: WeatherViewModel
    
    
    internal var imageCache = ImageCacheManager.shared
    
    init(weatherData: Weather, viewModel: WeatherViewModel) {
        self.weatherData = weatherData
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    @ViewBuilder func renderWeatherIcon() -> some View {
        
        VStack {
            
            if let iconImage = weatherImage {
                
                Image(uiImage: iconImage)
                    .resizable()
                    .frame(width: 300,height: 300)
                    .accessibilityIdentifier("weatherIconImage")
                
                
            } else {
                
                ProgressView()
                    .controlSize(.large)
                    .task {
                        self.weatherImage = await viewModel.fetchWeatherIcon(from: weatherData)
                    }
                
            }
        }
    }
    
   
    var body: some View {

        renderWeatherIcon()
            .padding()
        
    }
}

#Preview {
    WeatherIconView(weatherData: .defaultWeather, viewModel: WeatherViewModel(weatherManager: WeatherManager(), locationManager: LocationManager()))
}
