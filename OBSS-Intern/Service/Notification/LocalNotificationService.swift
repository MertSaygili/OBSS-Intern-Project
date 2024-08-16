//
//  LocalNotificationService.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 14.08.2024.
//

import Foundation
import UserNotifications

enum NotificationSplittedKey: String {
    case key = "$0$1$"
}

enum SplittedKeyResults: Int {
    case id = 1
    case title = 2
}

// Local Notification Service
class LocalNotificationService {
    // singleton instance
    static let shared = LocalNotificationService()
    
    private let favoriteMoviesRepository: FavoriteMovieRepositoryProtocol = FavoriteMovieRepository()
    private let movieService: MovieServiceProtocol = MovieService()
    
    // private constructor
    private init() {}
    
    func requestNotificationPermission() {
        requestAuthorization()
    }
    
    func initNotifications() {
        // check if there is already scheduled notifications and schedule missing notifications
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                // check if there is already scheduled notifications
                var hasThirtyMinuteNotification = false
                var hasOneHourNotification = false
                var hasOneDayNotification = false
                
                for request in requests {
                    if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                        switch trigger.timeInterval {
                        case LocalNotificationIntervals.thirtyMinute.timeInterval:
                            hasThirtyMinuteNotification = true
                        case LocalNotificationIntervals.oneHour.timeInterval:
                            hasOneHourNotification = true
                        case LocalNotificationIntervals.oneDay.timeInterval:
                            hasOneDayNotification = true
                        default:
                            break
                        }
                    }
                }
                
                // add missing notifications
                var intervals: [LocalNotificationIntervals] = []
                if !hasThirtyMinuteNotification {
                    intervals.append(.thirtyMinute)
                }
                if !hasOneDayNotification {
                    intervals.append(.oneDay)
                }
                
                if !intervals.isEmpty {
                    self.getDiscoverMovies(for: intervals)
                }
                
                // get favorite movies and send one hour notification
                let movies = self.favoriteMoviesRepository.getFavoriteMovies()
                if !movies.isEmpty && !hasOneHourNotification {
                    if let randomMovie = movies.randomElement() {
                        if let movieId = randomMovie.movieId {
                            self.getRecommendedMovies(movieId: movieId, for: [.oneHour])
                        }
                    }
                }
                
                // send three day notification and refresh this notification in login
                self.cancelNotification(withIdentifier: LocalNotificationIntervals.threeDays.getIdentifer)
                self.scheduleNotification(
                    title: LocalizationKeys.LocaleNotification.moviesAreWaiting.localize(),
                    body: LocalizationKeys.LocaleNotification.uDidNotEnterLongTime.localize(),
                    timeInterval: LocalNotificationIntervals.threeDays.timeInterval,
                    identifier: LocalNotificationIntervals.threeDays.getIdentifer
                )
            }
        }
    }
    
    // request user permission for sending notification
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                debugPrint("Notification authorized")
            } else {
                debugPrint("Notification authorization denied")
            }
        }
    }
    
    // schedules notification
    private func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    // cancels notifications
    private func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // cancel all
    private func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // check is there scheduled notification
    private func isNotificationScheduled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(!requests.isEmpty)
        }
    }
    
    // get discover movies and schedule notifications, for 30 minutes and one day intervals
    private func getDiscoverMovies(for intervals: [LocalNotificationIntervals]) {
        let page = Int.random(in: 1...20)
        movieService.getDisoverMovies(page: page) { result in
            switch result {
            case .success(let response):
                let movies = response.results ?? []
                guard !movies.isEmpty else { return }
                
                for interval in intervals {
                    if let randomMovie = movies.randomElement() {
                        let title: String
                        let identifier: String
                        
                        switch interval {
                        case .thirtyMinute:
                            title = LocalizationKeys.LocaleNotification.haveUWatchedThisMovie.localize()
                            identifier = "\(LocalNotificationIntervals.thirtyMinute.getIdentifer)\(NotificationSplittedKey.key.rawValue)\(randomMovie.id ?? 100)\(NotificationSplittedKey.key.rawValue)\(randomMovie.title ?? "")"
                        case .oneDay:
                            title = LocalizationKeys.LocaleNotification.uWillLikeThisMovie.localize()
                            identifier = "\(LocalNotificationIntervals.oneDay.getIdentifer)\(NotificationSplittedKey.key.rawValue)\(randomMovie.id ?? 100)\(NotificationSplittedKey.key.rawValue)\(randomMovie.title ?? "")"
                        default:
                            title = LocalizationKeys.LocaleNotification.newMovieRecommendation.localize()
                            identifier = "\(LocalNotificationIntervals.week.getIdentifer)\(NotificationSplittedKey.key.rawValue)\(randomMovie.id ?? 100)\(NotificationSplittedKey.key.rawValue)\(randomMovie.title ?? "")"
                        }
                        self.scheduleNotification(title: title, body: randomMovie.title ?? "", timeInterval: interval.timeInterval, identifier: identifier)
                    }
                }
            case .failure(let error):
                debugPrint("Error getting discover movies: \(error.localizedDescription)")
            }
        }
    }

    // get recommended movies and schedule notifications, for one day interval
    private func getRecommendedMovies(movieId: Int, for intervals: [LocalNotificationIntervals]) {
        movieService.getMovieRecommendations(movieId: movieId) {
            switch $0 {
            case .success(let response):
                let movies = response.results ?? []
                guard !movies.isEmpty else { return }
                
                for interval in intervals {
                    if let randomMovie = movies.randomElement() {
                        let title: String
                        let identifier: String
                        
                        switch interval {
                        case .oneHour:
                            title = LocalizationKeys.LocaleNotification.thisMovieIsForYou.localize()
                            identifier = "\(LocalNotificationIntervals.oneHour.getIdentifer)\(NotificationSplittedKey.key.rawValue)\(randomMovie.id ?? 100)\(NotificationSplittedKey.key.rawValue)\(randomMovie.title ?? "")"
                        default:
                            title = LocalizationKeys.LocaleNotification.recommendedMovie.localize()
                            identifier = "\(LocalNotificationIntervals.week.getIdentifer)\(NotificationSplittedKey.key.rawValue)\(randomMovie.id ?? 100)\(NotificationSplittedKey.key.rawValue)\(randomMovie.title ?? "")"
                        }
                        self.scheduleNotification(title: title, body: randomMovie.title ?? "", timeInterval: interval.timeInterval, identifier: identifier)
                    }
                }
            case .failure(let error):
                debugPrint("Error getting recommended movies: \(error.localizedDescription)")
            }
        }
    }
}
