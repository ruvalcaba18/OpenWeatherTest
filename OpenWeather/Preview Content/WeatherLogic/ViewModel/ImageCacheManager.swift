//
//  ImageCacheManager.swift
//  OpenWeather
//
//  Created by The Coding Kid on 02/10/2024.
//

import Foundation
import UIKit

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    private let cache =  NSCache<NSURL, UIImage>()
    
    private init() { }
    
    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
