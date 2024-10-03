//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import Foundation
import Combine

@MainActor final class WeatherViewModel: ObservableObject {
    
    private let weatherManager: WeatherManager
    private let locationManager: LocationManager
    
    @Published var weather: Weather?
    @Published var errorMessage: String = ""
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
        
        do {
            weather = try await weatherManager.getWeather(for: city)
            errorMessage = ""
            
        } catch let error  {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func fetchWeatherForCurrentLocation() async {
        
        guard let location = locationManager.currentLocation else {
            errorMessage = WeatherError.locationUnavailable.localizedDescription
            return
        }
        
        isLoading = true
        
        do {
            weather = try await weatherManager.getWeather(for: location)
            errorMessage = ""
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
        if let error = error as? WeatherError {
            errorMessage = error.localizedDescription
        } else {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }
}
