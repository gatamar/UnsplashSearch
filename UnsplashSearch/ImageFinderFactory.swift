//
//  UnsplashImageFinder.swift
//  UnsplashSearch
//
//  Created by Olha Pavliuk on 7/18/19.
//  Copyright © 2019 org. All rights reserved.
//

import Foundation
import UIKit
import os

private class UnsplashImageFinder: NSObject, ImageFinder {
    
    static let pointsOfInterest = OSLog(subsystem: "com.apple.SolarSystem", category: .pointsOfInterest)
    func findImage(tags: [String], completion: @escaping (_ image: UIImage?) -> Void) {
        os_signpost(.begin, log: UnsplashImageFinder.pointsOfInterest, name: "findImage")
        let searchURL = url(for: tags)
        print(searchURL)
        
        let task = URLSession.shared.dataTask(with: URL(string: searchURL)!) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let mimeType = httpResponse.mimeType else {
                    self.handleServerError(response)
                    return
            }
            
            os_signpost(.end, log: UnsplashImageFinder.pointsOfInterest, name: "findImage")
            
            let knownImageTypes = ["image/jpeg", "image/png"]
            if !knownImageTypes.contains(mimeType) {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data!)
            completion(image)
        }
        task.resume()
    }
    
    private func url(for tags: [String]) -> String {
        let basicURL = "https://source.unsplash.com/featured/?"
        
        if tags.isEmpty {
            return basicURL
        }
        let tagsSuffix = tags.reduce("") { (res, elem) -> String in
            return res + "," + elem
        }
        return basicURL + tagsSuffix.suffix(tagsSuffix.count-1)
    }
    
    private func handleServerError(_ response: URLResponse?) {
        // TODO
        print("handleServerError: not implemented")
    }
}

class UnsplashFinderFactory: ImageFinderFactory {
    func imageFinder() -> ImageFinder {
        return UnsplashImageFinder()
    }
}
