//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import Foundation
import Combine
import CoreLocation

@MainActor final class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var weather: Weather?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isPermissionDenied: Bool = false
    @Published var searchQuery: String = "" {
        didSet{
            if searchQuery.count > 3 {
                fetchWeather(for: searchQuery)
            }
        }
    }
    
    private let apiKey = "d7af7289c6bacbe828167f48a603368a"
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        
        authorizationStatus = status
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            isPermissionDenied = true
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("tiene permiso")
        @unknown default:
            break
        }
    }
    
    func fetchWeather(for city: String) async {
        isLoading = true
        do {
            weather = try await getWeather(for: city)
            errorMessage = ""
        } catch {
            errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func fetchWeatherForCurrentLocation() async {
        guard let location = currentLocation else {
            errorMessage = "Location not available"
            return
        }
        
        isLoading = true
        do {
            weather = try await getWeather(for: location)
            errorMessage = ""
        } catch {
            errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func performRequest(with urlString: String) async throws -> Weather {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Weather.self, from: data)
    }
    
    func getWeather(for city: String) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        return try await performRequest(with: urlString)
    }
    
    func getWeather(for location: CLLocation) async throws -> Weather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
        return try await performRequest(with: urlString)
    }
    
    
     func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isPermissionDenied = true
        default:
            break
        }
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to find user's location: \(error.localizedDescription)"
    }
}
