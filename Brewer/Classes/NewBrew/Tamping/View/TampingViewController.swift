//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension TampingViewController: Activable { }
extension TampingViewController: ThemeConfigurationContainer { }

final class TampingViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()
    
    private lazy var tampingView = TampingView()

    var active: Bool = false
    var themeConfiguration: ThemeConfiguration?
    let viewModel: TampingViewModelType

    init(viewModel: TampingViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tampingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = BrewAttributeType.tampStrength.description

        tampingView.sliderView.slider.value = viewModel.tampingValue.value
        tampingView.sliderView.slider.rx.value.bindTo(viewModel.tampingValue).addDisposableTo(disposeBag)
        tampingView.informativeLabel.text = viewModel.informativeText

        setupDefaultBackBarButtonItemIfNeeded()
        enableSwipeToBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tampingView.configure(with: themeConfiguration)
    }
}
