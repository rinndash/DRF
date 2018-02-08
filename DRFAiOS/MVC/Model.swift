//
//  MVCModel.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import Foundation

class Model {
    var leftOperand: Int?
    var rightOperand: Int?
    var result: Int? { return leftOperand.flatMap { x in rightOperand.map { y in x + y } } }
}
