//
//  AnalyticRepository.swift
//  Login
//
//  Created by David Diego Gomez on 24/03/2022.
//

import Foundation

protocol LeanplumRepositoryAnalyticsProtocol {
    func trackScreen(name: String, parameters: [String: Any])
    
    func trackEvent(event: String, parameters: [String: Any])
    
    func setUserID(userId: String)
}

class LeanplumRepositoryAnalytics: LeanplumRepositoryAnalyticsProtocol {
    func trackScreen(name: String, parameters: [String: Any]) {
        var params = parameters
        //        params[AnalyticsParameterScreenName] = name
        //        trackEvent(event: AnalyticsEventScreenView, parameters: params)
        print("\(name) \(params)")
    }
    
    func trackEvent(event: String, parameters: [String: Any]) {
        //        Analytics.logEvent(event, parameters: parameters)
        print("\(event) \(parameters)")
        
    }
    
    func setUserID(userId: String) {
        //        Analytics.setUserID(userId)
        print("\(userId)")
        
    }
}
