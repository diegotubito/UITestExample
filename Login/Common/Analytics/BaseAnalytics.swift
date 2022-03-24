//
//  BaseAnalytics.swift
//  Login
//
//  Created by David Diego Gomez on 24/03/2022.
//

import Foundation

protocol BaseAnalyticsProtocol {
    func firebaseTrackScreen(name: String, parameters: [String: Any])
    func firebaseTrackEvent(event: String, parameters: [String: Any])
    func firebaseSetUserID(userId: String)
    
    
    func leanplumTrackScreen(name: String, parameters: [String: Any])
    func leanplumTrackEvent(event: String, parameters: [String: Any])
    func leanplumSetUserID(userId: String)
}

class BaseAnalytics: BaseAnalyticsProtocol {
    var firebaseRepositoryAnalytics: FirebaseRepositoryAnalyticsProtocol
    var leanplumRepositoryAnalytics: LeanplumRepositoryAnalyticsProtocol
    
    init(firebaseAnalytics: FirebaseRepositoryAnalyticsProtocol = FirebaseRepositoryAnalytics(),
         leanplumAnalytics: LeanplumRepositoryAnalyticsProtocol = LeanplumRepositoryAnalytics()) {
        self.firebaseRepositoryAnalytics = firebaseAnalytics
        self.leanplumRepositoryAnalytics = leanplumAnalytics
    }
    
    // conforming protocol
    func firebaseTrackScreen(name: String, parameters: [String : Any]) {
        self.firebaseRepositoryAnalytics.trackScreen(name: name, parameters: parameters)
    }
    
    func firebaseTrackEvent(event: String, parameters: [String: Any]) {
        self.firebaseRepositoryAnalytics.trackEvent(event: event, parameters: parameters)
    }
    
    func firebaseSetUserID(userId: String) {
        self.firebaseRepositoryAnalytics.setUserID(userId: "userID")
    }
    
    
    
    
    func leanplumTrackScreen(name: String, parameters: [String : Any]) {
        self.leanplumRepositoryAnalytics.trackScreen(name: name, parameters: parameters)
    }
    
    func leanplumTrackEvent(event: String, parameters: [String: Any]) {
        self.leanplumRepositoryAnalytics.trackEvent(event: event, parameters: parameters)
    }
    
    func leanplumSetUserID(userId: String) {
        self.leanplumRepositoryAnalytics.setUserID(userId: "userID")
    }
    
    
}
