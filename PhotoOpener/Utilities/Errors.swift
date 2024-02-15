import UIKit

enum PhotoError: String, Error {
    case invalidURL
    case unableToFavorite
    case alreadyInFavorites
    case fetchingData
}

