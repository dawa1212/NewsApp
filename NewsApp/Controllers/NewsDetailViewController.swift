import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    var newsURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(webView)
        

        guard let url = newsURL else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}
