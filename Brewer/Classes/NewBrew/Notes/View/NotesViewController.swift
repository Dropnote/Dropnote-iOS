//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension NotesViewController: Activable { }
extension NotesViewController: ThemeConfigurationContainer { }

final class NotesViewController: UIViewController {
    fileprivate let disposeBag = DisposeBag()

    private var notesTextView: UITextView {
        return notesView.textView
    }
    private lazy var notesView = NotesView()

    var active: Bool = false {
        didSet {
            if isViewLoaded {
                notesView.textView.active = active
            }
        }
    }
    
    let viewModel: NotesViewModelType
    var themeConfiguration: ThemeConfiguration?

    init(viewModel: NotesViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = notesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = BrewAttributeType.notes.description
        notesTextView.text = viewModel.notes.value
        notesTextView.rx.text.bindTo(viewModel.notes).addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesView.configure(with: themeConfiguration)
    }
}
