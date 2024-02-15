import UIKit

class PhotosCell: UITableViewCell {
    
    static let reuseID = "PhotoCell"
    
    let thumbnail = ThumbnailView(frame: .zero)
    let photoTitle = PhotoTitleLabel(textAlignment: .left, fontSize: 20)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photo: Photo, isThumbnail: Bool) {
        if isThumbnail {
            thumbnail.downloadThumbnail(fromURL: photo.thumbnailUrl)
        }
        photoTitle.text = photo.title
    }
    
    private func configure() {
        
        addSubview(thumbnail)
        addSubview(photoTitle)
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            thumbnail.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            thumbnail.heightAnchor.constraint(equalToConstant: 60),
            thumbnail.widthAnchor.constraint(equalToConstant: 60),
            
            photoTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            photoTitle.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 24),
            photoTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            photoTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
