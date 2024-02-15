import UIKit

class PhotoListVC: LoadingViewVC {
    
    var photos: [Photo] = []
    var currentPage = 1
    var itemsPerPage = 100
    var isLoading = false
    var tableView: UITableView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureListVC()
        configureTableView()
        fetchPhotos(page: currentPage)
    }
    
    func configureListVC() {
        view.backgroundColor = .systemBackground
        title = "Фото"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.register(PhotosCell.self, forCellReuseIdentifier: PhotosCell.reuseID)
        view.addSubview(tableView)
    }
    
    func fetchPhotos(page: Int) {
        isLoading = true
        showLoadingView()
        
        Task {
            do {
                let data = try await NetworkManager.shared.fetchData(page: page, limit: itemsPerPage)
                let fetchedPhotos = try NetworkManager.shared.decoder.decode([Photo].self, from: data)
                updateUI(with: fetchedPhotos)
                dismissLoadingView()
                isLoading = false
            } catch {
                if let photoError = error as? PhotoError {
                    presentErrorAlert(message: photoError.rawValue)
                }
                dismissLoadingView()
                isLoading = false
            }
        }
    }
    
    func updateUI(with fetchedPhotos: [Photo]) {
        if fetchedPhotos.isEmpty {
            return
        }
        self.photos.append(contentsOf: fetchedPhotos)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setNeedsUpdateContentUnavailableConfiguration()
        }
    }
}

extension PhotoListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
        let photo = photos[indexPath.row]
        cell.set(photo: photo, isThumbnail: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.row]
        let detailVC = PhotoDetailViewController(photo: selectedPhoto)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard !isLoading else { return }
            currentPage += 1
            fetchPhotos(page: currentPage)
        }
    }
}
