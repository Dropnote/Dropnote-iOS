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
	var assembler: Assembler!
	var themeConfiguration: ThemeConfiguration?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if !DEBUG
            Fabric.with([Crashlytics.self])
        #else
            if ProcessInfo.processInfo.arguments.contains("use_mock_data") {
                loadMockData()
            }
        #endif
		return true
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		loadReveal()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		let stack: StackType = assembler.resolver.resolve(StackType.self)!
		stack.save().subscribe().addDisposableTo(disposeBag)
	}
}

extension AppDelegate: ThemeConfigurationContainer { }

extension SwinjectStoryboard {
    class func setup() {
        do {
            let assembler = try Assembler(assemblies: [
                CoreComponentsAssembly(),
                SettingsAssembly(),
                NewBrewAssembly(),
                BrewingsAssembly(),
				BrewingsSortingAssembly(),
                BrewDetailsAssembly(),
                BrewScoreDetailsAssembly(),
                ], propertyLoaders: nil, container: defaultContainer)
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.assembler = assembler
                appDelegate.themeConfiguration = assembler.resolver.resolve(ThemeConfiguration.self)
            }            
        } catch {
            XCGLogger.severe("Fatal error when initializer container: \(error)")
        }
    }
}
