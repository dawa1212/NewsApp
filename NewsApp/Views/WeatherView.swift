import UIKit

protocol WeatherViewDelegate: AnyObject {
    func didTapForecastButton()
}

class WeatherView: UIView {
    
    weak var delegate: WeatherViewDelegate?
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "rainy")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let countryName: UILabel = {
        let country = UILabel()
        country.font = .systemFont(ofSize: 30, weight: .light)
        country.textAlignment = .center
        country.textColor = .white
        country.translatesAutoresizingMaskIntoConstraints = false
        return country
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 86, weight: .light)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .light)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let forecastButton: UIButton = {
        let button = UIButton()
        button.setTitle("Weather Forecast", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapForecastButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(backgroundImageView)
        addSubview(countryName)
        addSubview(temperatureLabel)
        addSubview(weatherConditionLabel)
        addSubview(weatherIconImageView)
        addSubview(forecastButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            countryName.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            countryName.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: countryName.bottomAnchor, constant: 20),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            weatherConditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            weatherConditionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            weatherIconImageView.topAnchor.constraint(equalTo: weatherConditionLabel.bottomAnchor, constant: 20),
            weatherIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 60),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 60),
            
            forecastButton.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 20),
            forecastButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            forecastButton.widthAnchor.constraint(equalToConstant: 240),
            forecastButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    @objc  func didTapForecastButton() {
        delegate?.didTapForecastButton()
        
    }
    
    func updateUI(with weather: WeatherApiResponse) {
        countryName.text = weather.name
        
        let temperatureCelsius = weather.main.temp - 273.15
        temperatureLabel.text = String(format: "%.2f°C", temperatureCelsius)
        
        if let weatherInfo = weather.weather.first {
            
            let description = weatherInfo.description
            weatherConditionLabel.text = description
            
            
            let weatherType = WeatherType(rawValue: weatherInfo.main.rawValue) ?? .clear
            let backgroundImage = weatherType.asset.background
            backgroundImageView.image = backgroundImage
            
            let weatherIcon = weatherType.asset.icon
            weatherIconImageView.image = weatherIcon
        }
    }
}
