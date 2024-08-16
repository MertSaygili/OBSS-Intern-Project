//
//  ImageExtension.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 1.08.2024.
//

import Foundation

typealias ImageExtension = String

typealias GetImageExtension = String

extension ImageExtension{
    var getOrginalImage: String{
        return "\(NetworkConstants.originalImagePath)\(self)"
    }
    
    var getW500Image: String{
        return "\(NetworkConstants.w500ImagePath)\(self)"
    }
    
    var getW200Image: String{
        return "\(NetworkConstants.w200ImagePath)\(self)"
    }
}
