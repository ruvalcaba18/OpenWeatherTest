//
//  WeatherDetailsView.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import SwiftUI

struct WeatherDetailsView: View {
    
    let weather: Weather
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Temperature: \(String(format: "%.1f", weather.main.temp.rounded()))°C")
            Text("Humidity: \(weather.main.humidity)%")
            Text("Description: \(weather.weather.first?.description ?? "")")
        }
        .padding()
    }
}


#Preview {
    WeatherDetailsView(weather: .defaultWeather)
}
