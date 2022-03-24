//
//  LoginAnalytics.swift
//  Login
//
//  Created by David Diego Gomez on 24/03/2022.
//

import Foundation

class LoginAnalytics: BaseAnalytics {
    func customEvent(platform: AnalyticPlatforms) {
        switch platform {
        case .Firebase:
            firebasePlatform()
            break
        case .Leanplum:
            leanplumPlatform()
            break
        case .All:
            firebasePlatform()
            leanplumPlatform()
            break
        case .None:
            break
        }
        
    }
    
    private func leanplumPlatform() {
        leanplumRepositoryAnalytics.trackScreen(name: "leanplum", parameters: ["key":"value"])
    }
    
    private func firebasePlatform() {
        firebaseRepositoryAnalytics.trackScreen(name: "firebase", parameters: ["key":"value"])
    }
}
