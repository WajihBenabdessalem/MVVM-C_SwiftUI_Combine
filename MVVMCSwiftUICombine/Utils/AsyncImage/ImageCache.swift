//
//  ImageCache.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/25/24.
//

import UIKit
import SwiftUI

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100 // 100 items
        cache.totalCostLimit = 1024 * 1024 * 20 // ~20 MB
        return cache
    }()
    //
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil ?
            cache.removeObject(forKey: key as NSURL) :
            cache.setObject(newValue!, forKey: key as NSURL)
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
