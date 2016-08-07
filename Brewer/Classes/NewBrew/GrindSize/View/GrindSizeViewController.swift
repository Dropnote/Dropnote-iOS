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
    private let disposeBag = DisposeBag()
    @IBOutlet weak var informativeLabel: InformativeLabel!
    @IBOutlet weak var sliderContainerView: GrindSizeSliderContainerView!    
    @IBOutlet weak var numericValueTextField: UITextField! {
        didSet {
            numericValueTextField.delegate = self
            numericValueTextField.tintColor = .clearColor()
        }
    }
    @IBOutlet weak var switchButton: UIButton! {
        didSet {
            setButtonTitle(switchButton)
        }
    }
    
    var active: Bool = false {
        didSet {
            guard let responder = numericValueTextField else { return }
            guard let viewModel = viewModel else { return }
            if !viewModel.isSliderVisible && active {
                responder.becomeFirstResponder()
            }
        }
    }
    
    var themeConfiguration: ThemeConfiguration?    
    var viewModel: GringSizeViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = BrewAttributeType.GrindSize.description
        informativeLabel.text = viewModel.informativeText
        
        sliderContainerView.slider.continuous = false
        numericValueTextField.text = viewModel.inputTransformer.initialString()
        
        sliderContainerView.hidden = !viewModel.isSliderVisible
        numericValueTextField.hidden = viewModel.isSliderVisible
        
        sliderContainerView.slider.rx_value.bindTo(viewModel.sliderValue).addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.configureWithTheme(themeConfiguration)
        informativeLabel.configureWithTheme(themeConfiguration)
        sliderContainerView.configureWithTheme(themeConfiguration)
        numericValueTextField.configureWithTheme(themeConfiguration)
        showKeyboardIfNeeded()
    }
    
    @IBAction func switchInputRepresentation(sender: UIButton) {        
        numericValueTextField.hidden = !numericValueTextField.hidden
        sliderContainerView.hidden = !sliderContainerView.hidden
        viewModel.isSliderVisible = !sliderContainerView.hidden
        setButtonTitle(sender)
        showKeyboardIfNeeded()
    }
    
    private func showKeyboardIfNeeded() {
        if viewModel.isSliderVisible {
            numericValueTextField.resignFirstResponder()
        } else {
            numericValueTextField.becomeFirstResponder()
        }
    }
    
    private func setButtonTitle(button: UIButton) {
        let buttonTitle = !viewModel.isSliderVisible
            ? tr(.GrindSizeSliderButtonTitle)
            : tr(.GrindSizeNumericButtonTitle)
        button.setTitle(buttonTitle, forState: .Normal)
    }
}

extension GrindSizeViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count <= 1 else {
            return false
        }
        let textValue = viewModel.inputTransformer.transform(withRange: range, replacementString: string)
        textField.text = textValue
        viewModel.numericValue.value = textValue
        return false
    }
}
