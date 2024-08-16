//
//  MovieImage.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 15.08.2024.
//

import UIKit
import Kingfisher

typealias GetMovieImageExtension = UIImageView

extension GetMovieImageExtension {
    func setImage(with posterPath: String?) {
        guard let posterPath = posterPath else {
            self.image = AppImageConstants.posterPlaceholderImage
            return
        }
        
        let imageURLString: String = posterPath.getW500Image
        
        if let url = URL(string: imageURLString) {
            self.kf.setImage(with: url, placeholder: AppImageConstants.posterPlaceholderImage)
        } else {
            self.image = AppImageConstants.posterPlaceholderImage
        }
    }
}
