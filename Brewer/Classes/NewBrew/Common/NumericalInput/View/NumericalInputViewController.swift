//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension NumericalInputViewController: ThemeConfigurationContainer { }
extension NumericalInputViewController: Activable { }

final class NumericalInputViewController: UIViewController {
    var active: Bool = false {
        didSet {
            if isViewLoaded {
                numericalInputView.inputTextField.active = active
            }
        }
    }

    fileprivate var inputTextField: NumericalInputTextField {
        return numericalInputView.inputTextField
    }
    fileprivate var informativeLabel: InformativeLabel {
        return numericalInputView.informativeLabel
    }
    fileprivate lazy var numericalInputView = NumericalInputView()

    let viewModel: NumericalInputViewModelType
    var themeConfiguration: ThemeConfiguration?

    init(viewModel: NumericalInputViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = numericalInputView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        informativeLabel.text = viewModel.informativeText
        inputTextField.text = viewModel.inputTransformer.initialString() + viewModel.unit
        if let currentValue = viewModel.currentValue {
            inputTextField.text = currentValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.configure(with: themeConfiguration)
    }
}

extension NumericalInputViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count <= 1 else {
            return false
        }
        let textValue = viewModel.inputTransformer.transform(withRange: range, replacementString: string)
        textField.text = textValue + viewModel.unit
        viewModel.setInputValue(textValue)
        return false
    }
}
