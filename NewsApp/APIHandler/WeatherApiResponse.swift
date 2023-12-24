import Foundation
import UIKit

struct WeatherApiResponse: Codable {
    let name: String
    let timezone: Double
    let main: MainWeather
    let weather: [WeatherInfo]
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherInfo: Codable {
    let main: WeatherType
    let description: String

}

struct WeatherAssets: Codable {
    let iconName: String
    let backgroundName: String
    
    var icon: UIImage {
        return UIImage(systemName: iconName) ?? UIImage()
    }

    var background: UIImage {
        return UIImage(named: backgroundName) ?? UIImage()
    }
}

enum WeatherType: String, Codable {
    case rainy = "Rain"
    case cloudy = "Clouds"
    case snow = "Snow"
    case clear = "Clear"

    var asset: WeatherAssets {
        switch self {
        case .rainy:
            return WeatherAssets(iconName: "cloud.rain.fill",
                                  backgroundName: "rainy")
        case .cloudy:
            return WeatherAssets(iconName: "cloud.fill",
                                  backgroundName: "cloud")
        case .snow:
            return WeatherAssets(iconName: "cloud.snow.fill",
                                  backgroundName: "snow")
        case .clear:
            return WeatherAssets(iconName: "sun.max.fill",
                                  backgroundName: "sunny")
        }
    }
}
