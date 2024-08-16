//
//  ChatBotAvatars.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import Foundation
import UIKit

struct ChatBotAvatars{
    static let botImage: UIImage = UIImage(named: "chatbot") ?? UIImage()
    static let bearImage: UIImage = UIImage(named: "bear_avatar") ?? UIImage()
    static let catImage: UIImage = UIImage(named: "cat_avatar") ?? UIImage()
    static let dogImage: UIImage = UIImage(named: "dog_avatar") ?? UIImage()
    static let foxImage: UIImage = UIImage(named: "fox_avatar") ?? UIImage()
    static let pandaImage: UIImage = UIImage(named: "panda_avatar") ?? UIImage()
    static let beeImage: UIImage = UIImage(named: "bee_avatar") ?? UIImage()
    static let owlImage: UIImage = UIImage(named: "owl_avatar") ?? UIImage()
    static let elephantImage: UIImage = UIImage(named: "elephant_avatar") ?? UIImage()
    
    static let userAvatarList: [UIImage] = [bearImage, catImage, dogImage, foxImage, pandaImage, beeImage, owlImage, elephantImage]
}
