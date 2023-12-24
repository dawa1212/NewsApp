import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherForecastTableViewCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        addSubview(titleLabel)
        addSubview(temperatureLabel)
        addSubview(timeLabel)
        
       
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
  
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
    }
    
    func configure(with forecastItem: WeatherForecastItem) {
        let temperatureCelcius = forecastItem.main.temp! - 273.15

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: Date(timeIntervalSince1970: forecastItem.dt))
        timeLabel.text = "Time: \(formattedTime) \n Weather: \(forecastItem.weather.first?.description ?? "") \n Temperature: \(String(format: "%.2f°C", temperatureCelcius))"
    
    }
}

