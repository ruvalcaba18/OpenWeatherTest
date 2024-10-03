//
//  WeatherError.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import Foundation

enum WeatherError: LocalizedError, Equatable {
    
    case invalidURL
    case networkError(String)
    case decodingError
    case locationUnavailable
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The weather service is currently unavailable. Please try again later."
        case .networkError(let message):
            return message
        case .decodingError:
            return "Failed to decode the weather data. Please try again."
        case .locationUnavailable:
            return "Could not determine your location."
        case .noInternetConnection:
            return "No internet connection available, Please check your connection."
        }
    }
    
    static func == (lhs: WeatherError, rhs: WeatherError) -> Bool {
        
          switch (lhs, rhs) {
              
          case (.invalidURL, .invalidURL):
              return true
              
          case let (.networkError(message1), .networkError(message2)):
              return message1 == message2
              
          case (.decodingError, .decodingError):
              return true
              
          case (.locationUnavailable, .locationUnavailable):
              return true
              
          default:
              return false
          }
      }
}
