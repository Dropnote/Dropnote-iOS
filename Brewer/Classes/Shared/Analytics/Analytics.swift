//
// Created by Maciej Oczko on 24.07.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

final class Analytics {
    
    static let sharedInstance = Analytics()
    
    private var tracker: GAITracker?
    
    private init() {
        #if !DEBUG
            setup()
            tracker = GAI.sharedInstance().defaultTracker
        #endif
    }
    
    // MARK: Setup

    private func setup() {
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if let error = error {
            print("Error configuring Google services: \(error.localizedDescription)")
        }
        
        
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true
        gai.logger.logLevel = GAILogLevel.Warning
    }
    
    // MARK: Events
    
    func trackScreen(withTitle title: String) {
        tracker?.set(kGAIScreenName, value: title)
        tracker?.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject: AnyObject])
    }
    
    func trackMethodPickEvent(onScreen screen: String, method: BrewMethod) {
        tracker?.send(
            GAIDictionaryBuilder.createEventWithCategory(
                screen,
                action: "Selected",
                label: method.rawValue,
                value: 1)
                .build() as [NSObject: AnyObject]
        )
    }
}
