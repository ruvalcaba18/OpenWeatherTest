//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor final class WeatherViewModel: ObservableObject {
    
    private let weatherManager: WeatherManager
    private let locationManager: LocationManager
    private let imageCache = ImageCacheManager.shared
    
    @Published var weather: Weather?
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isPermissionDenied: Bool = false
    @Published var searchQuery: String = "" {
        didSet {
            if searchQuery.count > 3 {
                Task {
                    await fetchWeather(for: searchQuery)
                }
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherManager: WeatherManager, locationManager: LocationManager) {
        
        self.weatherManager = weatherManager
        self.locationManager = locationManager
        
        setupBindings()
    }
    
    func fetchWeather(for city: String) async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            weather = try await weatherManager.getWeather(for: city)
            errorMessage = nil
            
        } catch let error  {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func fetchWeatherForCurrentLocation() async {
        
        errorMessage = nil
        
        guard let location = locationManager.currentLocation else {
            errorMessage = WeatherError.locationUnavailable.localizedDescription
            return
        }
        
        isLoading = true
        
        do {
            weather = try await weatherManager.getWeather(for: location)
            errorMessage = nil
        } catch let error{
            handleError(error)
        }
        isLoading = false
    }
    
    private func setupBindings() {
        
        locationManager.$isPermissionDenied
            .receive(on: DispatchQueue.main)
            .assign(to: \.isPermissionDenied, on: self)
            .store(in: &cancellables)
        
        locationManager.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    func checkLocationPermission() {
        
        if locationManager.authorizationStatus == .notDetermined {
            
            locationManager.checkLocationAuthorization()
            
        } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
            
            isPermissionDenied = true
            
        }
    }
    
    private func handleError(_ error: Error) {
        weather = nil
        if let error = error as? WeatherError {
            errorMessage = error.localizedDescription
        } else {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }
    
     func fetchWeatherIcon(from weatherData: Weather) async -> UIImage? {
        
         do {
             guard let iconCode = weatherData.weather.first?.icon else {
                 errorMessage = "Icon code not found"
                 return nil
             }
             guard let iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png") else {
                 errorMessage = "Invalid icon URL"
                 return nil
             }
             
             if let cachedImage = imageCache.getImage(for: iconURL) {
                 return cachedImage
             } else {
                 return try await downloadWeatherIcon(from: iconURL)
             }
         } catch {
             handleError(error)
             return nil
         }
    }
    
    private func downloadWeatherIcon(from url: URL) async throws -> UIImage? {
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let downloadedImage = UIImage(data: data) {
                imageCache.setImage(downloadedImage, for: url)
                return downloadedImage
            } else {
                errorMessage = "Failed to convert data to image"
                return nil
            }
        } catch {
            handleError(error)
            return nil
        }
        
    }

    
}
