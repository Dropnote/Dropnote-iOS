//
//  NotesViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 19.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NotesViewModelType {
    var notes: Variable<String> { get }
}

final class NotesViewModel: NotesViewModelType {
    private let disposeBag = DisposeBag()
    let brewModelController: BrewModelControllerType
    
    private(set) var notes = Variable("")
    
    init(brewModelController: BrewModelControllerType) {
        self.brewModelController = brewModelController
        notes.value = brewModelController.currentBrew()?.notes ?? ""
        notes.asDriver().driveNext(setNotesToBrew).addDisposableTo(disposeBag)
    }
    
    private func setNotesToBrew(notes: String) {
        brewModelController.currentBrew()?.notes = notes
    }
}
