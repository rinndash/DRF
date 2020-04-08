//
//  Cycle.swift
//  DRFAiOS
//
//  Created by jinseo on 2020/04/08.
//  Copyright © 2020 rinndash. All rights reserved.
//

import Foundation
import RxSwift

enum AddTwoNumbers {
    enum Event {
        case leftOperandDidChange(String?)
        case rightOperandDidChange(String?)
    }

    struct CycleModel {
        var leftOperand: Int?
        var rightOperand: Int?
        var result: Int? { return leftOperand.flatMap { x in rightOperand.map { y in x + y } } }
        
        static var initial: CycleModel { CycleModel() }
    }

    static func update(_ model: CycleModel, event: Event) -> CycleModel {
        switch event {
        case let .leftOperandDidChange(value):
            var newModel = model
            newModel.leftOperand = value.flatMap(Int.init)
            return newModel
            
        case let .rightOperandDidChange(value):
            var newModel = model
            newModel.rightOperand = value.flatMap(Int.init)
            return newModel
        }
    }

    static func viewModel(from model: CycleModel) -> CycleJSViewController.ViewModel { model.result?.description }

    static func program(_ event$: Observable<Event>) -> Observable<CycleJSViewController.ViewModel> {
        event$
            .scan(CycleModel.initial, accumulator: update)
            .map(viewModel)
    }
}

