//
//  ImageExtension.swift
//  MoviesListApp
//
//  Created by Adnan Ansari on 13/07/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    // created a function to load the image in the imageView without SDwebImage
    func loadPosterImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
