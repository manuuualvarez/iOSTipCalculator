//
//  AmountView.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import UIKit


class AmountView: UIView {
    //MARK: - Properties
    private let title: String
    private let textAlignment: NSTextAlignment
    
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        LabelFactory.build(
            text: title,
            font: ThemeFont.regular(ofSize: 18),
            textColor: ThemeColor.text,
            textAlignment: textAlignment
        )
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = textAlignment
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [.font : ThemeFont.bold(ofSize: 24)]
        )
        text.addAttributes([.font : ThemeFont.bold(ofSize: 16)], range: NSMakeRange(0, 1))
        label.attributedText = text
        label.textColor = ThemeColor.primary
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            amountLabel
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: - Initialization
    init(title: String, textAlignment: NSTextAlignment) {
        self.title = title
        self.textAlignment = textAlignment
        super.init(frame: .zero)
        layout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func layout() {
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    //MARK: - Public Methods
    func configure(_ value: Double) {
        let text = NSMutableAttributedString(
            string: "\(value.currencyFormatt)",
            attributes: [.font : ThemeFont.bold(ofSize: 24)]
        )
        text.addAttributes([.font : ThemeFont.bold(ofSize: 16)], range: NSMakeRange(0, 1))
        amountLabel.attributedText = text
    }
}
