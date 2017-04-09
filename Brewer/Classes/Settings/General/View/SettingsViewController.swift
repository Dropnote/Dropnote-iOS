//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift
import RxCocoa
import MessageUI

extension SettingsViewController: ThemeConfigurable { }
extension SettingsViewController: ThemeConfigurationContainer { }

final class SettingsViewController: UIViewController {
	private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.delegate = self
        return tableView
    }()

    var themeConfiguration: ThemeConfiguration?
    let resolver: ResolverType
	let viewModel: TableViewConfigurable

    init(viewModel: TableViewConfigurable, themeConfiguration: ThemeConfiguration? = nil, resolver: ResolverType = Assembler.sharedResolver) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        title = tr(.settingsItemTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
   		view = tableView
   	}

    override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.configureWithTableView(tableView)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.configure(with: themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settings)
    }
    
    fileprivate func showViewController(for indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
            case 0:
                let methodPickerViewController = resolver.resolve(MethodPickerViewController.self)!
                methodPickerViewController.enableSwipeToBack()
                _ = methodPickerViewController
                    .didSelectBrewMethodSubject
                    .observeOn(MainScheduler.asyncInstance)
                    .subscribe(onNext: {
                        brewMethod in
                        Analytics.sharedInstance.trackMethodPickEvent(onScreen: AppScreen.settings, method: brewMethod)
                        let sequenceSettingsViewController = self.resolver.resolve(SequenceSettingsViewController.self, argument: brewMethod)!
                        sequenceSettingsViewController.enableSwipeToBack()
                        sequenceSettingsViewController.navigationItem.leftBarButtonItem = self.createDefaultBackBarButtonItem()
                        self.navigationController?.pushViewController(sequenceSettingsViewController, animated: true)
                })
                methodPickerViewController.navigationItem.leftBarButtonItem = createDefaultBackBarButtonItem()
                navigationController?.pushViewController(methodPickerViewController, animated: true)
                break
            case 1:
                let unitsViewController = resolver.resolve(UnitsViewController.self)!
                unitsViewController.navigationItem.leftBarButtonItem = createDefaultBackBarButtonItem()
                self.navigationController?.pushViewController(unitsViewController, animated: true)
                break
            case 2:
                let storyboard = UIStoryboard(name: "About", bundle: nil)
                let aboutViewController = storyboard.instantiateInitialViewController()!
                aboutViewController.enableSwipeToBack()
                aboutViewController.navigationItem.leftBarButtonItem = createDefaultBackBarButtonItem()
                self.navigationController?.pushViewController(aboutViewController, animated: true)
                break
            case 3: showEmailForm(); break
            case 4: showAppStore(); break
            default: break
        }
    }
    
    private func showEmailForm() {
        if MFMailComposeViewController.canSendMail() {
            present(configuredMailComposeViewController(), animated: true, completion: nil)
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
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func showAppStore() {
        let dropnoteAppStoreID = "1112293581"
        let dropnoteLinkString = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(dropnoteAppStoreID)"
        guard let dropnoteURL = URL(string: dropnoteLinkString) else { return }
        UIApplication.shared.openURL(dropnoteURL)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("Error when sending mail = \(String(describing: error?.localizedDescription))")
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: TabBarConfigurable {
    
    func setupTabBar() {
        tabBarItem = UITabBarItem(title: tr(.settingsItemTitle),
                                  image: UIImage(asset: .Ic_tab_settings)?.alwaysOriginal(),
                                  selectedImage: UIImage(asset: .Ic_tab_settings_pressed)?.alwaysOriginal())

    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        cell.accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
        (cell as? SettingsCell)?.configure(with: themeConfiguration)
	}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showViewController(for: indexPath)
    }
}
