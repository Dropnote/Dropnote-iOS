//
//  AppDelegate.swift
//  Brewer
//
//  Created by Maciej Oczko on 23.11.2015.
//  Copyright © 2015 Maciej Oczko. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
import XCGLogger

#if !DEBUG
    import Fabric
    import Crashlytics
#endif

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	private let disposeBag = DisposeBag()

	var window: UIWindow?
	var assembler: Assembler!
	var themeConfiguration: ThemeConfiguration?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        #if !DEBUG
            Fabric.with([Crashlytics.self])
        #else
            if NSProcessInfo.processInfo().arguments.contains("use_mock_data") {
                loadMockData()
            }
        #endif
		return true
	}

	func applicationDidBecomeActive(application: UIApplication) {
		loadReveal()
	}

	func applicationDidEnterBackground(application: UIApplication) {
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
            
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                appDelegate.assembler = assembler
                appDelegate.themeConfiguration = assembler.resolver.resolve(ThemeConfiguration.self)
            }            
        } catch {
            XCGLogger.severe("Fatal error when initializer container: \(error)")
        }
    }
}
