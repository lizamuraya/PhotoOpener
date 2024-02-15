import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    let baseURL = "https://jsonplaceholder.typicode.com/photos"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    
    func fetchData(page: Int, limit: Int) async throws -> Data {
        guard let url = URL(string: "\(baseURL)?_page=\(page)&_limit=\(limit)") else {
            throw PhotoError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}


