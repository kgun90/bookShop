//
//  UI.swift
//  BookShop
//
//  Created by gkang on 7/1/24.
//

import UIKit

extension UIImageView {
    func setImage(url urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        ImageCacheManager.shared.setObject(image, forKey: urlString as NSString)
                    }
                }
            }
        }
    }
    
    func loadImage(_ imageUrlString: String?) {
        guard let imageUrlString = imageUrlString else { return }
        let cacheKey = NSString(string: imageUrlString)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        } else {
            self.setImage(url: imageUrlString)
        }
    }
}

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
