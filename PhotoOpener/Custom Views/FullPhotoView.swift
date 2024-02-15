import UIKit

class FullPhotoView: UIImageView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configure() {
            contentMode = .scaleAspectFit
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        func downloadPhoto(fromURL url : String) {
            Task { image = await NetworkManager.shared.downloadImage(from: url) ?? nil}
        }
}

