//
//  WeatherIconView.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import SwiftUI

struct WeatherIconView: View {
    
    let weather: Weather
    
    var body: some View {
        
        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "")@2x.png"))
            .frame(width: 300, height: 300)
            .padding()
            .accessibilityIdentifier("weatherIconImage")
        
    }
}

#Preview {
    WeatherIconView(weather: .defaultWeather)
}
