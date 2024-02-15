import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemPurple
        viewControllers = [createphotoListNC(), createFavoritesNC()]

    }
    func createphotoListNC() -> UINavigationController {
        let photoListNC = PhotoListVC()
        photoListNC.title = "Photos"
        photoListNC.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "photo.fill.on.rectangle.fill"), tag: 0)
            
        return UINavigationController(rootViewController: photoListNC)
    }
    

    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC()
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
}
