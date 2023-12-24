import UIKit
import SideMenu

protocol SideMenuDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

class SideMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: SideMenuDelegate?
    
    private let categories: [(name: String, imageName: String)] = [("Sports", "football.circle.fill"),
                                                                   ("Education", "books.vertical.circle.fill"),
                                                                   ("Health", "bolt.heart.fill"),
                                                                   ("Politics", "building.columns"),
                                                                   ("Tesla Models", "bolt.car.circle")]
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let headerLabel = UILabel()
        headerLabel.text = "News Categories"
        headerLabel.textColor = .systemGray
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        
        let iconImageView = UIImageView(image: UIImage(named: "logoNews"))
        iconImageView.tintColor = UIColor.systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        view.addSubview(iconImageView)
       
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            headerLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 60)
        ])


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.imageView?.image = UIImage(systemName: category.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let selectedCategory = categories[indexPath.row].name
            delegate?.didSelectCategory(selectedCategory)
        }
}
