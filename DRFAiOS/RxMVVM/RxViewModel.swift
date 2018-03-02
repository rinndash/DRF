//
//  ViewModel.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import Foundation
import RxSwift

class RxViewModel {
    var didChangeLeftOperand: AnyObserver<String?> { return leftOperandSubject.asObserver() }
    var didChangeRightOperand: AnyObserver<String?> { return rightOperandSubject.asObserver() }

    let result$: Observable<String?>
    
    private var leftOperandSubject: PublishSubject<String?> = PublishSubject()
    private var rightOperandSubject: PublishSubject<String?> = PublishSubject()
    
    init() {
        let leftOperand$ = leftOperandSubject
            .asObservable()
            .map { $0.flatMap(Int.init) }
            .filterNil()
        
        let rightOperand$ = rightOperandSubject
            .asObservable()
            .map { $0.flatMap(Int.init) }
            .filterNil()
        
        result$ = Observable.combineLatest(leftOperand$, rightOperand$)
            .map(+)
            .map { $0.description }
    }
}
