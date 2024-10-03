//
//  WeatherManager.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//
import Foundation
import CoreLocation

final class WeatherManager {
    
    private let apiKey = "d7af7289c6bacbe828167f48a603368a"
    
    private func performRequest(with urlString: String) async throws -> Weather {
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        do {
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw WeatherError.networkError("Invalid response from the server.")
            }
            
            do {
                return try JSONDecoder().decode(Weather.self, from: data)
            } catch {
                throw WeatherError.decodingError
            }
            
        } catch let urlError as URLError {
          
            if urlError.code == .notConnectedToInternet {
                throw WeatherError.noInternetConnection
            } else {
                throw WeatherError.networkError(urlError.localizedDescription)
            }
            
        } catch {
            throw WeatherError.networkError(error.localizedDescription)
        }
        
    }

    
    
    func getWeather(for city: String) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        return try await performRequest(with: urlString)
    }
    
   
    func getWeather(for location: CLLocation) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
        return try await performRequest(with: urlString)
    }
}

