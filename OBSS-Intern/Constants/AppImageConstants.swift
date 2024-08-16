//
//  IconConstants.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 30.07.2024.
//

import Foundation
import UIKit

// Null check error
struct AppImageConstants{
    // KEYS
    static let kStarFill: String = "star.fill"
    static let kStar: String = "star"
    static let kCalendar: String = "calendar"
    static let kTimer: String = "timer"
    static let kGlobe: String = "globe"
    static let kDolarSign: String = "dollarsign"
    static let kFillDolarSign: String = "dollarsign.circle.fill"
    static let kLocation: String = "location"
    static let kHouseFill: String = "house.fill"
    static let kMoon: String = "moon"
    static let kSun: String = "sun.min"
    static let kPaperplane: String  = "paperplane"
    static let kPlus = "plus"
    static let kList = "list.bullet"
    static let kMovieClapper = "movieclapper"
    static let kBookmark = "bookmark"
    static let kBookmarkFill = "bookmark.fill"
    
    // Lotttie keys
    static let kLottie404: String = "lottie-404"
    static let kLottieNotFound: String = "lottie-not-found"
    static let kLotteFavoriteNotFound: String = "lottie-favorite-not-found"
    static let kLottieSplash: String = "lottie-splash"

    // UIIMages --system
    static let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default)
    static let movieTabImage :UIImage = UIImage(systemName: "play.rectangle.fill", withConfiguration: config) ?? UIImage()
    static let searchMovieTabImage: UIImage = UIImage(systemName: "magnifyingglass", withConfiguration: config) ?? UIImage()
    static let favoritesTabImage: UIImage = UIImage(systemName: "heart", withConfiguration: config) ?? UIImage()
    static let personTabImage: UIImage = UIImage(systemName: "person", withConfiguration: config) ?? UIImage()
    static let calendarImage: UIImage = UIImage(systemName: kCalendar, withConfiguration: config) ?? UIImage()
    static let starImage: UIImage = UIImage(systemName: kStar, withConfiguration: config) ?? UIImage()
    static let heartFillImage: UIImage = UIImage(systemName: "heart.fill", withConfiguration: config) ?? UIImage()
    static let heartImage: UIImage = UIImage(systemName: "heart", withConfiguration: config) ?? UIImage()
    static let arrowLeftImage: UIImage = UIImage(systemName: "arrow.left", withConfiguration: config) ?? UIImage()
    static let locationImage: UIImage = UIImage(systemName: kLocation, withConfiguration: config) ?? UIImage()
    static let houseFillImage: UIImage = UIImage(systemName: kHouseFill, withConfiguration: config) ?? UIImage()
    static let movieClapperImage: UIImage = UIImage(systemName: kMovieClapper, withConfiguration: config) ?? UIImage()
    static let bookmarkImage: UIImage = UIImage(systemName: kBookmark, withConfiguration: config) ?? UIImage()
    static let bookmarkFilImage: UIImage = UIImage(systemName: kBookmarkFill, withConfiguration: config) ?? UIImage()

    // UIIMages --asset
    static let posterPlaceholderImage: UIImage = UIImage(named: "poster-placeholder.png") ?? UIImage()
    static let chatBotImage: UIImage = UIImage(named: "chatbot") ?? UIImage()
}
