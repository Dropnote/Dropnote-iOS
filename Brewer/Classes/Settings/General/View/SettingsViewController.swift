//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MessageUI

extension SettingsViewController: ThemeConfigurable { }
extension SettingsViewController: ThemeConfigurationContainer { }

final class SettingsViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

    var themeConfiguration: ThemeConfiguration?
	var viewModel: TableViewConfigurable!

	override func viewDidLoad() {
		super.viewDidLoad()
        title = tr(.SettingsItemTitle)
        
		tableView.tableFooterView = UIView()
		tableView.delegate = self
		viewModel.configureWithTableView(tableView)
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settings)
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if case .MethodPicker = segueIdentifierForSegue(segue) {
            let methodPickerViewController = segue.destinationViewController as! MethodPickerViewController
            methodPickerViewController.enableSwipeToBack()
            
            _ = methodPickerViewController
                .didSelectBrewMethodSubject
                .observeOn(MainScheduler.asyncInstance)
                .subscribeNext {
                    brewMethod in
                    Analytics.sharedInstance.trackMethodPickEvent(onScreen: AppScreen.settings, method: brewMethod)
                    methodPickerViewController.performSegue(.SequenceSettings, sender: brewMethod.rawValue)
            }
        }
        if case .About = segueIdentifierForSegue(segue) {
            let aboutViewController = segue.destinationViewController as! AboutViewController
            aboutViewController.enableSwipeToBack()
        }
	}
    
    private func performSegueForIndexPath(indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: performSegue(.MethodPicker); break
        case 1: performSegue(.Units); break
        case 2: performSegue(.About); break
        case 3: showEmailForm(); break
        default: break
        }
    }
    
    private func showEmailForm() {
        if MFMailComposeViewController.canSendMail() {
            presentViewController(configuredMailComposeViewController(), animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.mailComposeDelegate = self
        
        mailComposerViewController.setToRecipients(["hello@dropnote.today"])
        mailComposerViewController.setSubject("Dropnote App Feedback")
        mailComposerViewController.setMessageBody("Hi Dropnote Team!\n\n", isHTML: false)
        
        return mailComposerViewController
    }
    
    private func showMailError() {
        let alertController = UIAlertController(
            title: "Could Not Send Email",
            message: "Your device could not send e-mail. Please check e-mail configuration and try again.",
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        print("Error when sending mail = \(error?.localizedDescription)")
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SettingsViewController: TabBarConfigurable {
    
    func setupTabBar() {
        tabBarItem = nil
        tabBarItem = UITabBarItem(title: tr(.SettingsItemTitle),
                                  image: UIImage(asset: .Ic_tab_settings)?.alwaysOriginal(),
                                  selectedImage: UIImage(asset: .Ic_tab_settings_pressed)?.alwaysOriginal())

    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = true
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = false
    }

	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
        cell.accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
        (cell as? SettingsCell)?.configureWithTheme(themeConfiguration)
	}

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueForIndexPath(indexPath)
    }
}
