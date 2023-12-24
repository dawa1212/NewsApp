import UIKit
import WeatherKit
import CoreLocation

class WeatherController: UIViewController, CLLocationManagerDelegate, WeatherViewDelegate {
    private let weatherView = WeatherView()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(weatherView)
        
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        weatherView.delegate = self
    }
    
    func didTapForecastButton() {
        
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude else {
            
            print("Unable To get Location")
            return
        }
        
        let forecastVC = WeatherForecastController(latitude: latitude, longitude: longitude)
        
        navigationController?.pushViewController(forecastVC, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        print("Received location update: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    private func fetchWeather(latitude: Double, longitude: Double) {
        ApiHandler.shared.getWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self?.weatherView.updateUI(with: weather)
                }
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
        }
    }
    
    deinit {
        self.locationManager.stopUpdatingLocation()
    }
}
