import Foundation

struct News {
    let title: String
    let subTitle: String
    let imageURL: URL?
    let channelImageURL: URL? 

    init(title: String, subTitle: String, imageURL: URL?, channelImageURL: URL?) {
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
        self.channelImageURL = channelImageURL
    }
}

