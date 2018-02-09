//
//  RXSwift+DRFA.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import RxSwift

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
}

extension ObservableType {
    func zipWithPrevious(initial: E) -> Observable<(E, E)> {
        return scan((initial, initial), accumulator: { ($0.1, $1) })
    }
}

protocol CopyableStruct {
    func copy(with transform: (inout Self) -> Void) -> Self
}

extension CopyableStruct {
    func copy(with transform: (inout Self) -> Void) -> Self {
        var copy = self
        transform(&copy)
        return copy
    }
}
