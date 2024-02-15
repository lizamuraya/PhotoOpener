import UIKit

class ThumbnailView: UIImageView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadThumbnail(fromURL url : String) {
        Task { image = await NetworkManager.shared.downloadImage(from: url) ?? nil }
    }
}
