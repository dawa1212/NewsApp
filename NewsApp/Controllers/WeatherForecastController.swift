import UIKit

class WeatherForecastController: UIViewController {
    
    private var forecastItems = [String: [WeatherForecastItem]]()
    private var sectionTitles = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(WeatherForecastTableViewCell.self, forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
        super.init(nibName: nil,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Forecast"
        view.backgroundColor = .systemOrange
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchWeatherForecast()
    }
    
    private func fetchWeatherForecast() {
        ApiHandler.shared.getWeatherForecast(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let forecast):
                DispatchQueue.main.async {
                    self?.groupForecastItemsByDay(forecast.list)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func groupForecastItemsByDay(_ items: [WeatherForecastItem]) {
        for item in items {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let day = dateFormatter.string(from: Date(timeIntervalSince1970: item.dt))
            
            if var existingItems = forecastItems[day] {
                existingItems.append(item)
                forecastItems[day] = existingItems
            } else {
                forecastItems[day] = [item]
            }
        }
        
        sectionTitles = forecastItems.keys.sorted()
    }
}

extension WeatherForecastController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = sectionTitles[section]
        return forecastItems[day]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier, for: indexPath) as? WeatherForecastTableViewCell else {
            return UITableViewCell()
        }
        
        let day = sectionTitles[indexPath.section]
        if let forecastItem = forecastItems[day]?[indexPath.row] {
            cell.configure(with: forecastItem)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .systemOrange
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: sectionTitles[section]) {
            dateFormatter.dateFormat = "EEEE, MMM d"
            let formattedDateString = dateFormatter.string(from: date)
            titleLabel.text = formattedDateString
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
