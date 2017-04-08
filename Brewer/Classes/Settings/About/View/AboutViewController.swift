//
// Created by Maciej Oczko on 27.07.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension AboutViewController: ThemeConfigurable { }
extension AboutViewController: ThemeConfigurationContainer { }

final class AboutViewController: UITableViewController {

    var themeConfiguration: ThemeConfiguration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.settingsAboutMenuItemTitle)
        configure(with: themeConfiguration)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.configure(with: themeConfiguration)
        (cell as? AboutViewPhotoCell)?.configure(with: themeConfiguration)
        
        cell.contentView.subviews.forEach {
            ($0 as? UILabel)?.configure(with: themeConfiguration)
        }
    }
}
