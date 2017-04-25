//
// Created by Maciej Oczko on 17.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class SelectableSearchResultViewCell: UITableViewCell {

	func configure(with theme: ThemeConfiguration?) {
		super.configure(with: theme)
		textLabel?.configure(with: theme)
	}
}
