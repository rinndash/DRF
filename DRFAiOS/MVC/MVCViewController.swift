//
//  ViewController.swift
//  DRFAiOS
//
//  Created by 윤진서 on 2018. 2. 9..
//  Copyright © 2018년 rinndash. All rights reserved.
//

import UIKit
import SnapKit

class MVCViewController: UIViewController {
    weak var leftOperandTextField: UITextField?
    weak var rightOperandTextField: UITextField?
    weak var resultLabel: UILabel?
    
    var model: Model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Views
        let leftTextField = UITextField()
        self.leftOperandTextField = leftTextField
        leftTextField.font = UIFont.systemFont(ofSize: 25)
        leftTextField.placeholder = "0"
        leftTextField.keyboardType = .numberPad
        leftTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        leftTextField.textAlignment = .center
        leftTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let operatorLabel = UILabel()
        operatorLabel.textAlignment = .center
        operatorLabel.text = "+"
        
        let rightTextField = UITextField()
        self.rightOperandTextField = rightTextField
        rightTextField.font = UIFont.systemFont(ofSize: 25)
        rightTextField.placeholder = "0"
        rightTextField.keyboardType = .numberPad
        rightTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        rightTextField.textAlignment = .center
        rightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let equalSignLabel = UILabel()
        equalSignLabel.textAlignment = .center
        equalSignLabel.text = "="
        
        let resultLabel = UILabel()
        resultLabel.font = UIFont.systemFont(ofSize: 25)
        resultLabel.textAlignment = .center
        resultLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.resultLabel = resultLabel
        
        let container = UIView()
        container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        let stackView = UIStackView(arrangedSubviews: [
            leftTextField,
            operatorLabel,
            rightTextField,
            equalSignLabel,
            resultLabel
            ])
        stackView.distribution = .fillEqually
        container.addSubview(stackView)
        
        // Layout
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        view.addSubview(container)
        container.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let number = sender.text.map(Int.init) else { return }
        
        if sender == leftOperandTextField {
            model.leftOperand = number
        } else if sender == rightOperandTextField {
            model.rightOperand = number
        }
        
        resultLabel?.text = model.result?.description
    }
}
