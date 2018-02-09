//
//  ReactViewController.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import UIKit
import RxSwift

class ReactViewController: UIViewController {
    let vdomView: VDomView = VDomView<RxModel>()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(vdomView)
        vdomView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension RxModel: CopyableStruct {
    func asVDom() -> VDom<RxModel> {
        return InsetView.insetView(
            baseItem: UIStackView.stack(
                id: "stack",
                nodes: [
                    UITextField.textField(id: "leftOperandTextField",
                                          property: .init(
                                            placeHolder: "0",
                                            backgroundColor: UIColor.lightGray.withAlphaComponent(0.5),
                                            fontSize: 25,
                                            didChangeText: Function<String?, RxModel>(key: "didChangeLeftOperandCallBack") { (text: String?) in
                                                return self.copy { $0.leftOperand = text.flatMap(Int.init) }
                                            }
                        )
                    ),
                    UILabel.label(id: "+", property: .init(text: "+", backgroundColor: UIColor.clear, fontSize: 15)),
                    UITextField.textField(id: "rightOperandTextField",
                                          property: .init(
                                            placeHolder: "0",
                                            backgroundColor: UIColor.lightGray.withAlphaComponent(0.5),
                                            fontSize: 25,
                                            didChangeText: Function<String?, RxModel>(key: "didChangeRightOperandCallBack") { (text: String?) in
                                                return self.copy { $0.rightOperand = text.flatMap(Int.init) }
                                            }
                        )
                    ),
                    UILabel.label(id: "=", property: .init(text: "=", backgroundColor: UIColor.clear, fontSize: 15)),
                    UILabel.label(id: "resultLabel", property: .init(text: result?.description, backgroundColor: UIColor.lightGray.withAlphaComponent(0.5), fontSize: 25)),
                    ]
            )
        )
    }
}
