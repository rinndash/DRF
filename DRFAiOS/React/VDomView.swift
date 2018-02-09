//
//  VDomView.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import UIKit
import RxSwift

class VDomView<Message>: UIView {
    private var itemView: UIView?
    private var vdom: VDom<Message>?
        
    private func removeItemView() {
        itemView?.removeFromSuperview()
    }
    
    private func addItemView(itemView: UIView) {
        addSubview(itemView)
        itemView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        itemView.setContentHuggingPriority(.required, for: .vertical)
        self.itemView = itemView
    }
    
    func update(vdom: VDom<Message>?) -> Observable<Message> {
        guard self.vdom != vdom else { return Observable.empty() }
        switch (self.vdom, vdom) {
        case let (.some(old), .some(new)) where old.id != new.id:
            self.removeItemView()
            let subview = new.view()
            self.addItemView(itemView: subview)
            return new.update(subview)
            
        case let (.some(old), .some(new)) where old.id == new.id:
            guard let itemView = self.itemView else { fatalError("불가능") }
            return new.update(itemView)
            
        case (.some, .none):
            self.removeItemView()
            return Observable.empty()
            
        case let (.none, .some(new)):
            let subview = new.view()
            self.addItemView(itemView: subview)
            return new.update(subview)
            
        case (.none, .none):
            return Observable.empty()
        
        default:
            fatalError("불가능")
        }
    }
}
