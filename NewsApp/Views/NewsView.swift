import UIKit
import SDWebImage

class NewsViewcell: UITableViewCell {
    static let identifier = "NewsViewcell"

    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .secondarySystemBackground
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    private let channelImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .orange
        image.layer.cornerRadius = 14
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    private let newsTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 22, weight: .semibold)
        title.numberOfLines = 0
        return title
    }()

    private let newsSubTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17, weight: .light)
        title.numberOfLines = 0
        return title
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(channelImageView)
        contentView.addSubview(newsTitle)
        contentView.addSubview(newsSubTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Adjust the frame based on your design
        newsImageView.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.width - 20,
            height: contentView.frame.size.height/2
        )

        channelImageView.frame = CGRect(
            x: 10,
            y: 225,
            width: 30,  // Adjusted width based on design
            height: 30  // Adjusted height based on design
        )

        newsTitle.frame = CGRect(
            x: 10,  // Adjusted x position based on design
            y: contentView.frame.size.height/2,
            width: contentView.frame.width - 20,
            height: 70
        )

        newsSubTitle.frame = CGRect(
            x: 50,  // Adjusted x position based on design
            y: contentView.frame.size.height/2 + 70,
            width: contentView.frame.width - 20,
            height: 50 // Adjusted height based on design
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        channelImageView.image = nil  // Clear the channel image
        newsTitle.text = nil
        newsSubTitle.text = nil
    }

    func configure(with viewModel: News, weatherType: WeatherType) {
        if let newsURL = viewModel.imageURL {
            newsImageView.sd_setImage(with: newsURL,
                                      placeholderImage: nil,
                                      options: .highPriority,
                                      completed: nil)
        }

        if let channelURL = viewModel.channelImageURL {
            channelImageView.sd_setImage(with: channelURL,
                                         placeholderImage: nil,
                                         options: .highPriority,
                                         completed: nil)
        }

        newsTitle.text = viewModel.title
        newsSubTitle.text = viewModel.subTitle
    }
}
