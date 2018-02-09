//
//  VirtualDom.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import UIKit
import Differ
import RxSwift

struct VDom<Message>: Equatable {
    let id: String
    let view: () -> UIView
    let update: (UIView) -> Observable<(Message)>
    
    let property: Any
    let isEqualTo: (Any) -> Bool
    
    static func ==(lhs: VDom, rhs: VDom) -> Bool {
        guard lhs.id == rhs.id else { return false }
        return lhs.isEqualTo(rhs)
    }
}

extension VDom {
    init<T>(id: String, property: T, view: @escaping () -> UIView, update: @escaping (UIView) -> Observable<Message>) where T: Equatable {
        self.id = id
        self.property = property
        self.view = view
        self.update = update
        self.isEqualTo = { (any: Any) -> Bool in
            guard let anotherProperty = any as? T else { return false }
            return property == anotherProperty
        }
    }
}

struct Function<A, B>: Equatable {
    let key: String
    let f: (A) -> B
    
    static func ==(lhs: Function, rhs: Function) -> Bool {
        return lhs.key == rhs.key
    }
}

extension UILabel {
    struct Property: Equatable {
        let text: String?
        let backgroundColor: UIColor
        let fontSize: CGFloat
        
        static func ==(lhs: Property, rhs: Property) -> Bool {
            return lhs.text == rhs.text
                && lhs.backgroundColor == rhs.backgroundColor
                && lhs.fontSize == rhs.fontSize
        }
    }
    
    static func label<Message>(id: String, property: Property) -> VDom<Message> {
        return VDom(
            id: id,
            property: property,
            view: {
                let label = UILabel()
                label.textAlignment = .center
                return label
            },
            update: { (view: UIView) -> Observable<Message> in
                guard let label = view as? UILabel else { return Observable.empty() }
                label.text = property.text
                label.backgroundColor = property.backgroundColor
                label.font = UIFont.systemFont(ofSize: property.fontSize)
                return Observable<Message>.empty()
            }
        )
    }
}

private var textFieldEventDisposeBag = DisposeBag()

extension UITextField {
    struct Property<Message>: Equatable {
        let placeHolder: String?
        let backgroundColor: UIColor
        let fontSize: CGFloat
        let didChangeText: Function<String?, Message>
        
        static func ==(lhs: Property, rhs: Property) -> Bool {
            return lhs.placeHolder == rhs.placeHolder
                && lhs.backgroundColor == rhs.backgroundColor
                && lhs.fontSize == rhs.fontSize
                && lhs.didChangeText == rhs.didChangeText
        }
    }
    
    static func textField<Message>(id: String, property: Property<Message>) -> VDom<Message> {
        return VDom(
            id: id,
            property: property,
            view: {
                let textField = UITextField()
                textField.textAlignment = .center
                textField.keyboardType = .numberPad
                return textField
        },
            update: { (view: UIView) -> Observable<Message> in
                guard let textField = view as? UITextField else { return Observable<Message>.empty() }
                textFieldEventDisposeBag = DisposeBag()
                textField.placeholder = property.placeHolder
                textField.backgroundColor = property.backgroundColor
                textField.font = UIFont.systemFont(ofSize: property.fontSize)
                return textField.rx.text
                    .map(property.didChangeText.f)
            }
        )
    }
}

extension UIStackView {
    private var subviewTags: [Int] { return arrangedSubviews.map { $0.tag } }
    
    struct Property<Message>: Equatable {
        let nodes: [VDom<Message>]
        
        static func ==(lhs: Property, rhs: Property) -> Bool {
            return lhs.nodes == rhs.nodes
        }
    }
    
    static func stack<Message>(id: String, nodes: [VDom<Message>]) -> VDom<Message> {
        return VDom(
            id: id,
            property: Property(nodes: nodes),
            view: {
                let stackView = UIStackView()
                stackView.distribution = .fillEqually
                return stackView
        },
            update: { (view: UIView) -> Observable<Message> in
                guard let stackView = view as? UIStackView else { return Observable.empty() }
                let oldTags: [Int] = stackView.subviewTags
                let newTags: [Int] = nodes.map { $0.id.hashValue }
                
                let diffs = oldTags.extendedDiff(newTags)
                diffs.forEach { diff in
                    //diffs.
                    switch diff {
                    case let .insert(idx):
                        let viewModel = nodes[idx]
                        let tag = newTags[idx]
                        let viewToInsert = viewModel.view()
                        viewToInsert.tag = tag
                        stackView.insertArrangedSubview(viewToInsert, at: idx)
                        
                    case let .delete(idx):
                        let tag = oldTags[idx]
                        guard let viewToRemove = stackView.viewWithTag(tag) else { return }
                        stackView.removeArrangedSubview(viewToRemove)
                        viewToRemove.removeFromSuperview()
                        
                    case let .move(from, to):
                        let tag = oldTags[from]
                        guard let viewToMove = stackView.viewWithTag(tag) else { return }
                        stackView.removeArrangedSubview(viewToMove)
                        stackView.insertArrangedSubview(viewToMove, at: to)
                    }
                }
                
                let message$s: [Observable<Message>] = zip(nodes, stackView.arrangedSubviews)
                    .map { vm, view in vm.update(view) }
                return Observable<Message>.merge(message$s)
            }
        )
    }
}

class InsetView: UIView {
    var baseItemView: UIView?
    static func insetView<Message>(baseItem: VDom<Message>) -> VDom<Message> {
        return VDom(
            id: baseItem.id,
            property: baseItem,
            view: {
                let view = InsetView()
                let baseView = baseItem.view()
                view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
                view.addSubview(baseView)
                baseView.snp.makeConstraints {
                    $0.edges.equalToSuperview().inset(20)
                }
                view.baseItemView = baseView
                return view
            },
            update: { (view: UIView) in
                guard
                    let insetView = view as? InsetView,
                    let baseView = insetView.baseItemView
                    else { return Observable.empty() }
                return baseItem.update(baseView)
            }
        )
    }
}
