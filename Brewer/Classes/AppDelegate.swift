//
//  AppDelegate.swift
//  Brewer
//
//  Created by Maciej Oczko on 23.11.2015.
//  Copyright © 2015 Maciej Oczko. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import RxSwift
import XCGLogger

#if !DEBUG
    import Fabric
    import Crashlytics
#endif

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	fileprivate let disposeBag = DisposeBag()

	var window: UIWindow?
	var themeConfiguration: ThemeConfiguration?
	let assembler: Assembler = try! Assembler(assemblies: [
			CoreComponentsAssembly(),
			SettingsAssembly(),
			NewBrewAssembly(),
			BrewingsAssembly(),
			BrewingsSortingAssembly(),
			BrewDetailsAssembly(),
			BrewScoreDetailsAssembly()
	])

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if !DEBUG
            Fabric.with([Crashlytics.self])
        #else
            if ProcessInfo.processInfo.arguments.contains("use_mock_data") {
                loadMockData()
            }
        #endif
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = assembler.resolver.resolve(RootViewController.self)!
        window?.makeKeyAndVisible()
		return true
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		loadReveal()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		let stack: StackType = assembler.resolver.resolve(StackType.self)!
		stack.save().subscribe().addDisposableTo(disposeBag)
	}
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        guard let rootViewController = application.keyWindow?.rootViewController as? RootViewController else {
            completionHandler(false)
            return
        }
        
        let brewMethod = BrewMethod.fromQuickType(string: shortcutItem.type)
        rootViewController.showNewBrewVieController(for: brewMethod)
        completionHandler(true)
    }

	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
		let rootViewController = window?.rootViewController as? RootViewController		
		rootViewController?.brewingsViewController?.restoreUserActivityState(userActivity)
		return true
	}

}

extension AppDelegate: ThemeConfigurationContainer { }

