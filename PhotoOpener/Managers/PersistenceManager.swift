import Foundation

enum PersistenceActionType {
    case add
    case remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Photo, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                    
                case .add:
                    guard !favorites.contains(where: { $0.id == favorite.id }) else {
                        completed(PhotoError.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.id == favorite.id }
                }
                
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Photo], PhotoError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Photo].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Photo]) -> PhotoError? {
        do {
            let encoder = JSONEncoder()
            let encoderFavorites = try encoder.encode(favorites)
            defaults.set(encoderFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    static func isFavorite(_ photo: Photo) -> Bool {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return false
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Photo].self, from: favoritesData)
            return favorites.contains(where: { $0.id == photo.id })
        } catch {
            return false
        }
    }
}
