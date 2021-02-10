//
//  ImageCache.swift
//  MovieSearcher
//
//  Created by Angelina Wu on 08/02/2021.
//  Copyright © 2021 notungood. All rights reserved.
//

import Foundation
import UIKit

// Might add some features later

class ImageCache {
    static var shared = ImageCache()
    
    private var cache = [String: UIImage]()
    
    private init() { }
    
    func download(fromURL url: URL, onCompletion: @escaping ((UIImage) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                onCompletion(image)
            }
        }).resume()
    }
    
    func getImage(from imageURL: URL, onCompletion: @escaping ((UIImage) -> Void)) {
        
        if let imageAlreadyDownloaded = imageCache[imageURL.absoluteString] {
            onCompletion(imageAlreadyDownloaded)
        } else {
            download(fromURL: imageURL, onCompletion: { image in
                imageCache[imageURL.absoluteString] = image
                onCompletion(image)
            })
        }
    }
}
