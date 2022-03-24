//
//  FirebaseAnalyticRepository.swift
//  Login
//
//  Created by David Diego Gomez on 24/03/2022.
//

import Foundation

protocol FirebaseRepositoryAnalyticsProtocol {
    func trackScreen(name: String, parameters: [String: Any])
    
    func trackEvent(event: String, parameters: [String: Any])
    
    func setUserID(userId: String)
}

class FirebaseRepositoryAnalytics: FirebaseRepositoryAnalyticsProtocol {
    func trackScreen(name: String, parameters: [String: Any]) {
        var params = parameters
        //        params[AnalyticsParameterScreenName] = name
        //        trackEvent(event: AnalyticsEventScreenView, parameters: params)
        print("\(name) \(params)")
    }
    
    func trackEvent(event: String, parameters: [String: Any]) {
        //        Analytics.logEvent(event, parameters: parameters)
    }
    
    func setUserID(userId: String) {
        //        Analytics.setUserID(userId)
    }
}

