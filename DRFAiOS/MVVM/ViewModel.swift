//
//  ViewModel.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel {
    private let model: Model = Model()
    
    var leftOperandString: String? {
        didSet {
            model.leftOperand = leftOperandString.flatMap(Int.init)
        }
    }
    var rightOperandString: String? {
        didSet {
            model.rightOperand = rightOperandString.flatMap(Int.init)
        }
    }

    var resultString: String? { return model.result?.description }
}
