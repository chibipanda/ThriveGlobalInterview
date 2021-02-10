import Foundation
import UIKit

// for performance reason, easier to make this a global
// variable for now.
var imageCache = [String: UIImage]()

// The next thing I'd like to have done is to make this Decodable
// That way, when we get the JSON from apple. we'll just get the
// JSONDecoder to decode straight to here, save some lines in the
// SearchLogicController
struct Movie {
    let movieTitle: String?
    let movieSummary: String?
    let imageURL: URL?
}
