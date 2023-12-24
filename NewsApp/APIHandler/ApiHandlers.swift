import Foundation
import WeatherKit

class ApiHandler {
    static let shared = ApiHandler()
    
    private let weatherApiKey = "4cddd8cc65efeefeab46bedc245b4dde"
    private let newsApiKey = "3f93ce28d6e54549bb6e5fa6f64e351c"
    
    private init() {}
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
    
    enum Endpoint {
        case weather(latitude: Double, longitude: Double)
        case weatherForecast(latitude: Double, longitude: Double)
        case topStories
        case search(query: String)
        case newsForCategory(category: String)
        
        var url: URL? {
            switch self {
            case let .weather(latitude, longitude):
                return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(ApiHandler.shared.weatherApiKey)")
            case let .weatherForecast(latitude, longitude):
                return URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(ApiHandler.shared.weatherApiKey)")
            case .topStories:
                return URL(string: "https://newsapi.org/v2/everything?q=apple&from=2023-12-09&to=2023-12-09&sortBy=popularity&apiKey=\(ApiHandler.shared.newsApiKey)")
            case let .search(query):
                return URL(string: "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=\(ApiHandler.shared.newsApiKey)&q=\(query)")
            case let .newsForCategory(category):
                return URL(string: "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=\(ApiHandler.shared.newsApiKey)&q=\(category)")
            }
        }
    }
    
    func fetchData<T: Decodable>(for endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherApiResponse, Error>) -> Void) {
        fetchData(for: .weather(latitude: latitude, longitude: longitude), completion: completion)
    }
    
    func getWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherDetailApiResponse, Error>) -> Void) {
        fetchData(for: .weatherForecast(latitude: latitude, longitude: longitude), completion: completion)
    }
    
    func getTopStories(completion: @escaping (Result<NewsApiResponse, Error>) -> Void) {
        fetchData(for: .topStories, completion: completion)
    }
    
    func search(with query: String, completion: @escaping (Result<NewsApiResponse, Error>) -> Void) {
        fetchData(for: .search(query: query), completion: completion)
    }
    
    func getNewsForCategory(_ category: String, completion: @escaping (Result<NewsApiResponse, Error>) -> Void) {
        fetchData(for: .newsForCategory(category: category), completion: completion)
    }
}
