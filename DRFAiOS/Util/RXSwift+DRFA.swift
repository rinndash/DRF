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

extension ObservableType where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return Observable<Element.Wrapped>.empty()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }
}

extension ObservableType {
    func zipWithPrevious(initial: Element) -> Observable<(Element, Element)> {
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
