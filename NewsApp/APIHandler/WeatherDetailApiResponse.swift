
import Foundation
import UIKit

struct WeatherDetailApiResponse: Codable {
    let list: [WeatherForecastItem]
    
}

struct WeatherForecastItem: Codable {
    let dt: TimeInterval
    let main: WeatherMain
    let weather: [WeatherDescription]
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}
struct WeatherMain: Codable {
    let temp: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}


struct WeatherDescription: Codable {
    let main: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
    }
    
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

