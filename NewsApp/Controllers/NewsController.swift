import UIKit
import SideMenu
import CoreLocation

class NewsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SideMenuDelegate {
    var menu: SideMenuNavigationController?

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsViewcell.self, forCellReuseIdentifier: NewsViewcell.identifier)
        return table
    }()

    private var weatherType: WeatherType = .clear
    private var articles = [Article]()
    private var viewModels = [News]()
    private let searchVC = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .white

        let imageView = UIImageView(image: UIImage(named: "news"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView

        let weatherButton = UIBarButtonItem(title: "Weather",
                                            image: UIImage(systemName: "cloud.sun.rain.fill"),
                                            target: self,
                                            action: #selector(didTapWeatherButton))
        navigationItem.rightBarButtonItem = weatherButton

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        menu = SideMenuNavigationController(rootViewController: SideMenuController())
        menu?.leftSide = true
        menu?.presentationStyle = .menuSlideIn
        menu?.menuWidth = view.bounds.width * 0.6
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(didTapMenu)
        )

        UINavigationBar.appearance().tintColor = .black
        fetchTopStories()
        createSearchBar()

        if let sideMenuVC = menu?.viewControllers.first as? SideMenuController {
            sideMenuVC.delegate = self
        }
    }

    @objc func didTapWeatherButton() {
        let weatherDetailsVC = WeatherController()
        navigationController?.pushViewController(weatherDetailsVC, animated: true)
    }

    @objc func didTapMenu() {
        present(menu!, animated: true)
    }

    private func fetchTopStories() {
        ApiHandler.shared.getTopStories { [weak self] result in
            guard let self else { return  }
            switch result {
            case .success(let articles):
                self.articles = articles.articles
                self.viewModels = self.articles.compactMap({
                    News(
                        title: $0.title ?? "No Title",
                        subTitle: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        channelImageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsViewcell.identifier,
            for: indexPath
        ) as? NewsViewcell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row], weatherType: weatherType)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]

        guard let urlString = article.url, let url = URL(string: urlString) else {
            showAlert(message: "Invalid Url")
            return
        }

        let newsDetailVC = NewsDetailViewController()
            newsDetailVC.newsURL = url
            navigationController?.pushViewController(newsDetailVC, animated: true)
        }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        ApiHandler.shared.search(with: text) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let articles):
                self.articles = articles.articles
                self.viewModels = self.articles.compactMap({
                    News(
                        title: $0.title ?? "No Title",
                        subTitle: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        channelImageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchVC.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func didSelectCategory(_ category: String) {
        print("Selected category: \(category)")

        ApiHandler.shared.getNewsForCategory(category) { [weak self] result in
            guard let self else { return}
            switch result {
            case .success(let articles):
                self.articles = articles.articles
                self.viewModels = self.articles.compactMap({
                    News(
                        title: $0.title ?? "No Title",
                        subTitle: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        channelImageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
