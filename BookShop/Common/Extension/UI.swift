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


extension UITextField {
    func setKeyboardDismiss() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button: UIBarButtonItem =  {
            let item = UIBarButtonItem()
            item.title = "닫기"
            item.target = self
            item.action = #selector(dismissAction)
            return item
        }()
        
        let toolBar: UIToolbar = {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            toolBar.setItems([flexSpace, button], animated: true)
            
            toolBar.isUserInteractionEnabled = true
            return toolBar
        }()
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func dismissAction() {
        self.endEditing(true)
    }
}

extension UIViewController {
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func endEditing() {
        self.view.endEditing(false)
    }
}
