//
//  BillInputView.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import UIKit

class BillInputView: UIView {
    
    private let headerView : HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Enter", bottomText: "your bill")
        return view
    }()
    
    private let textfieldContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius()
        return view
    }()
    
    private let currencyDenomainateLabel: UILabel = {
        let label = LabelFactory.build(text: "$", font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
      let tf = UITextField()
        tf.borderStyle = .none
        tf.font = ThemeFont.bold(ofSize: 28)
        tf.keyboardType = .decimalPad
        tf.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tf.textColor = ThemeColor.text
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBtn
        ]
        toolbar.isUserInteractionEnabled = true
        tf.inputAccessoryView = toolbar
        return tf
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, textfieldContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textfieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textfieldContainerView.snp.leading).offset(-24)
        }
        
        textfieldContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textfieldContainerView.addSubview(currencyDenomainateLabel)
        textfieldContainerView.addSubview(textField)
        
        currencyDenomainateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textfieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDenomainateLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textfieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc private func doneButtonTapped() {
        textField.endEditing(true)
    }
}
