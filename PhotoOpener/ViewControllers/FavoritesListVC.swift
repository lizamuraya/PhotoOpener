import UIKit

class FavoritesListVC: UIViewController {
   
    var favorites: [Photo] = []
    let tableView = UITableView()
    let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробуйте еще раз", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFavoritesVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureFavoritesVC() {
        view.backgroundColor = .systemBackground
        title = "Избранное"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.fill.viewfinder")
            config.text = "В избранном пока ничего нет 💔"
            config.secondaryText = "Добавьте новое фото в избранное"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                self.alert.message = "Что-то пошло не так"
            }
        }
    }
    
    func updateUI(with favorites: [Photo]) {
        self.favorites = favorites
        setNeedsUpdateContentUnavailableConfiguration()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(photo: favorite, isThumbnail: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let detailVC = PhotoDetailViewController(photo: favorite)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                self.setNeedsUpdateContentUnavailableConfiguration()
                return
            }
            
            DispatchQueue.main.async {
                self.alert.message = "Что-то пошло не так"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
}
