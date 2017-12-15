//
//  download-image.swift
//  Events Map
//
//  Created by Alan Luo on 11/7/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import Lottie

let imageCache = NSCache<AnyObject, AnyObject>()

class customImageView: UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        contentMode = mode
//        
//        image = nil
//        
//        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil
//                else { return }
//            DispatchQueue.main.async() {
//                let imageToCache = UIImage(data: data)
//                
//                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
//                
//                self.image = imageToCache
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode)
//    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        
        image = nil
        
//        let animationView = LOTAnimationView(name: "loader")
//        animationView.frame = frame
//        animationView.center = center
//        addSubview(animationView)
//        animationView.loopAnimation = true
//        animationView.play()
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
            DispatchQueue.main.async() {
                let imageToCache = UIImage(data: data)
//                animationView.stop()
//                animationView.removeFromSuperview()
                UIView.transition(with: self,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.image = imageToCache },
                                  completion: nil)
                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
