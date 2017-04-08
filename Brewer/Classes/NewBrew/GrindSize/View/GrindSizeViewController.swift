//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension GrindSizeViewController: Activable { }
extension GrindSizeViewController: ThemeConfigurationContainer { }

final class GrindSizeViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()

    lazy var grindSizeView = GrindSizeView()

    fileprivate var informativeLabel: InformativeLabel {
        return grindSizeView.informativeLabel
    }
    fileprivate var numericValueTextField: UITextField {
        return grindSizeView.textField
    }
    fileprivate var switchButton: UIButton {
        return grindSizeView.switchButton
    }
    fileprivate var sliderView: SliderView {
        return grindSizeView.sliderView
    }

    var active: Bool = false {
        didSet {
            guard isViewLoaded else { return }
            if !numericValueTextField.isHidden && active {
                numericValueTextField.becomeFirstResponder()
            }
        }
    }
    
    var themeConfiguration: ThemeConfiguration?    
    let viewModel: GrindSizeViewModelType

    init(viewModel: GrindSizeViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = grindSizeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = BrewAttributeType.grindSize.description
        informativeLabel.text = viewModel.informativeText

        setButtonTitle(isVisible: viewModel.isSliderVisible.value)

        numericValueTextField.delegate = self
        numericValueTextField.text = viewModel.inputTransformer.initialString()
        numericValueTextField.isHidden = viewModel.isSliderVisible.value

        sliderView.isHidden = !viewModel.isSliderVisible.value
        sliderView.slider.rx.value.bindTo(viewModel.sliderValue).addDisposableTo(disposeBag)

        switchButton.rx.tap.map { !self.viewModel.isSliderVisible.value }.bindTo(viewModel.isSliderVisible).addDisposableTo(disposeBag)
        switchButton.rx.tap.bindNext(showKeyboardIfNeeded).addDisposableTo(disposeBag)
        viewModel.isSliderVisible.asDriver().drive(sliderView.rx.isHidden).addDisposableTo(disposeBag)
        viewModel.isSliderVisible.asDriver().map(!).drive(numericValueTextField.rx.isHidden).addDisposableTo(disposeBag)
        viewModel.isSliderVisible.asDriver().drive(onNext: setButtonTitle).addDisposableTo(disposeBag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        grindSizeView.configureWithTheme(themeConfiguration)
        showKeyboardIfNeeded()
    }
    
    private func showKeyboardIfNeeded() {
        if viewModel.isSliderVisible.value {
            numericValueTextField.resignFirstResponder()
        } else {
            numericValueTextField.becomeFirstResponder()
        }
    }

    private func setButtonTitle(isVisible: Bool) {
        let buttonTitle = !isVisible ? tr(.grindSizeSliderButtonTitle) : tr(.grindSizeNumericButtonTitle)
        switchButton.setTitle(buttonTitle, for: .normal)
    }
}

extension GrindSizeViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count <= 1 else { return false }
        let textValue = viewModel.inputTransformer.transform(withRange: range, replacementString: string)
        textField.text = textValue
        viewModel.numericValue.value = textValue
        return false
    }
}
