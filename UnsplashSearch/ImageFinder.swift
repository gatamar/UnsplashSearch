//
//  ImageFinder.swift
//  UnsplashSearch
//
//  Created by Olha Pavliuk on 7/18/19.
//  Copyright © 2019 org. All rights reserved.
//

import Foundation
import UIKit

protocol ImageFinder {
    func findImage(tags: [String], completion: @escaping (_ image: UIImage?) -> Void)
}

protocol ImageFinderFactory {
    func imageFinder() -> ImageFinder
}
