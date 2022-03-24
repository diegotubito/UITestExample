//
//  BaseViewController.swift
//  Login
//
//  Created by David Diego Gomez on 24/03/2022.
//

import UIKit

class BaseViewController<TAnalytic>: UIViewController where TAnalytic: BaseAnalyticsProtocol {
    var analytics: TAnalytic!
    
    var analyticPlatform: AnalyticPlatforms {
        return AnalyticPlatforms.All
    }
    
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    internal func analyticsInit() {
        fatalError("analitycs need to be initialized at \(identifier)")
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        analyticsInit()
        trackScreen()
    }
}

extension BaseViewController {
    private func trackScreen() {
        switch analyticPlatform {
        case .Firebase:
            firebaseScreenTrack()
            break
        case .Leanplum:
            leanplumScreenTrack()
            break
        case .All:
            firebaseScreenTrack()
            leanplumScreenTrack()
            break
        case .None:
            break
        }
    }
    
    private func firebaseScreenTrack() {
        analytics.firebaseTrackScreen(name: "firebaseScreen", parameters: ["name": identifier])
    }
    
    private func leanplumScreenTrack() {
        analytics.leanplumTrackScreen(name: "leanplumScreen", parameters: ["name": identifier])
    }
}
