import Foundation

protocol SearchLogic {
    func getResults(forQuery query: String, onCompletion: @escaping ([Movie]) -> Void)
}

class SearchLogicController: SearchLogic {
    
    func getResults(forQuery query: String, onCompletion: @escaping ([Movie]) -> Void) {
        fetchNewResults(forQuery: query, onCompletion: onCompletion)
    }
}
    
extension SearchLogicController {
    
    func fetchNewResults(forQuery query: String, onCompletion: @escaping ([Movie]) -> Void) {
        guard let request = getConfiguredURLRequest(forQuery: query) else { return }
        let session = getConfiguredUrlSession()
        let task = session.dataTask(with: request, completionHandler: { [unowned self] (data, urlResponse, error) in
            guard error == nil, let data = data else { return }
            guard let movies = self.parseMovieSearchResponse(data: data) else { return }
            onCompletion(movies)
        })
        task.resume()
    }
    
    func getConfiguredURLRequest(forQuery query: String) -> URLRequest? {
        let baseURL = "https://itunes.apple.com/search?media=movie&limit=200&explicit=no&"
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "media", value: "movie"),
            URLQueryItem(name: "limit", value: "200"),
            URLQueryItem(name: "explicit", value: "no"),
            URLQueryItem(name: "term", value: query)
        ]
        
        guard let requestURl: URL = components?.url else { return nil }
        let request = URLRequest(url: requestURl, cachePolicy: .returnCacheDataElseLoad)
        return request
    }
    
    func getConfiguredUrlSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        return URLSession(configuration: config)
    }
    
    func parseMovieSearchResponse(data: Data) -> [Movie]? {
        guard let resultJson = ( try? JSONSerialization.jsonObject(with: data) ) else { return nil }
        guard let dataDictionary = resultJson as? [String:Any] else { return nil }
        guard let movieRecords = dataDictionary["results"] as? [[String:Any]] else { return nil }
        
        var movies = [Movie]()
        for eachRecord in movieRecords {
            let title = eachRecord["trackName"] as? String
            let summary = eachRecord["longDescription"] as? String
            let imagelocation = eachRecord["artworkUrl100"] as? String
            guard let imageURL = URL(string: imagelocation!) else { return nil }
            
            let newMovie = Movie(movieTitle: title, movieSummary: summary, imageURL: imageURL)
            movies.append(newMovie)
        }
        return movies
    }
}
