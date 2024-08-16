//
//  LocalizationKeys.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 29.07.2024.
//

import Foundation

// Extension of String, for getting localize meanin of variable
extension String {
    func localize() -> String{
        let language = Defaults.getString(key: UserDefaultKeys.language)
        
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

// localization keys, this struct for preventing misspelling
struct LocalizationKeys{
    struct Common{
        static let hello = "hello"
        static let unkown = "unkown"
        static let hourShort = "hourShort"
        static let minuteShort = "minuteShort"
        static let cancel = "cancel"
        static let change = "change"
        static let create = "create"
        static let delete = "delete"
    }
    struct Tabs{
        static let moviesTitle = "moviesTitle"
        static let searchMovieTitle = "searchMovieTitle"
        static let favoritesTitle = "favoritesTitle"
        static let profileTitle = "profileTitle"
    }
    struct Home{
        static let popularMoviesTitle = "popularMovies"
        static let upcomingMoviesTitle = "upcomingMovies"
    }
    struct MovieDetail{
        static let cast = "cast"
        static let crew = "crew"
        static let recommendedMovies = "recommendedMovies"
        static let productionCompanies = "productionCompanies"
        static let detailPage = "detailPage"
    }
    struct PersonDetail{
        static let cast = "castMovie"
        static let crew = "crewMovie"
    }
    struct Error{
        static let urlNotFound = "urlNotFound";
        static let homePageNotFound = "homePageNotFound";
        static let noCustomList = "noCustomList";
        static let invalidUrl = "invalidUrl";
        static let requestFailed = "noMovieFound";
        static let dataConversionFailed = "dataConversionFailed";
        static let unkownError = "unkownError";
        static let noDataFound = "noDataFound";
        static let decodingError = "decodingError";
        static let invalidResponse = "invalidResponse";
    }
    struct Favorites{
        static let favoritesTitle = "favorites"
    }
    struct Search{
        static let searchPlaceholder = "searchPlaceholder"
        static let searchTitle = "searchTitle"
    }
    struct Profile{
        static let profileTitle = "profileTitle"
        static let profileList = "profileList"
        static let createList = "createList"
        static let displayList = "displayList"
        static let deviceBrightness = "deviceBrightness"
        static let deviceLanguage = "deviceLanguage"
        static let generalTitle = "generalTitle"
        static let informationTitle = "informationTitle"
        static let contactUs = "contactUs"
        static let languageTitle = "langaugeTitle"
        static let changeLanguageTitle = "changeLanguageTitle"
        static let changeLanguageMessage = "changeLanguageMessage"
        static let enterListName = "enterListName"
        static let mailUs = "mailUs"
    }
    struct Languages{
        static let english = "english"
        static let turkish = "turkish"
    }
    struct ChatBot{
        static let chatBotPrompt = "chatBotPrompt"
        static let chatBot = "chatBot"
        static let writeMessage = "writeMessage"
        static let send = "send"
        static let welcomeMessage = "welcomeMessage"
        static let newSession = "newSession"
    }
    struct MovieList{
        static let movieList = "movieList"
        static let movies = "movies"
        static let listEmpty = "listEmpty"
        static let deleteListTitle = "deleteListTitle"
        static let deleteListMessage = "deleteListMessage"
    }
    struct LocaleNotification{
        static let haveUWatchedThisMovie = "haveUWatchedThisMovie"
        static let uWillLikeThisMovie = "uWillLikeThisMovie"
        static let newMovieRecommendation = "newMovieRecommendation"
        static let thisMovieIsForYou = "thisMovieIsForYou"
        static let recommendedMovie = "recommendedMovie"
        static let moviesAreWaiting = "moviesAreWaiting"
        static let uDidNotEnterLongTime = "uDidNotEnterLongTime"
    }
}

