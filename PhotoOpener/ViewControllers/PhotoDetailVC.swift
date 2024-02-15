import UIKit

class PhotoDetailViewController: LoadingViewVC {
    
    var imageView = FullPhotoView(frame: .zero)
    var photo: Photo
    var isFavorite: Bool = false
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .systemBackground
        navigationController?.navigationBar.tintColor = .systemPurple
    
        configureImage()
        configureFavoriteButton()
        imageView.downloadPhoto(fromURL: photo.url)
    }
    
    func configureImage() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureFavoriteButton() {
        let favoriteBarButton = UIBarButtonItem(image: UIImage(systemName: isFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = favoriteBarButton
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        PersistenceManager.updateWith(favorite: photo, actionType: isFavorite ? .remove : .add) { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            if let error {
                self.presentErrorAlert(message: "Не удалось \(self.isFavorite ? "удалить из" : "добавить в") избранное: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.isFavorite.toggle()
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: self.isFavorite ? "heart.fill" : "heart")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isFavorite = PersistenceManager.isFavorite(photo)
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
    }
}
