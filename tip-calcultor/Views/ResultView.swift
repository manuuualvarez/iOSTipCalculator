//
//  ResultView.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import UIKit

class ResultView: UIView {
    // MARK: - UI
    private let headerLabel = {
        LabelFactory.build(text: "Total p/person", font: ThemeFont.semiBold(ofSize: 18))
    }()
    
    private let amountPerPersonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [.font : ThemeFont.bold(ofSize: 48)]
        )
        text.addAttributes([.font : ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 1))
        label.attributedText = text
        label.textColor = ThemeColor.text
        
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private let totalBill: AmountView = {
        AmountView(title: "Total bill", textAlignment: .left)
    }()
    
    private let totalTip: AmountView = {
        AmountView(title: "Total tip", textAlignment: .right)
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            totalBill,
            UIView(),
            totalTip
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            amountPerPersonLabel,
            horizontalLineView,
            buildSpacerView(height: 0),//No need height because the container has an spacer
            hStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func layout() {
        backgroundColor = .white
        addSubview(vStackView)
        
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).inset(24)
            make.bottom.equalTo(snp.bottom).inset(24)
        }
        
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        addShadow(offset: CGSize(width: 0, height: 3), color: .black, radius: 12.0, opacity: 0.2)
    }
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
    
    // MARK: - Public Methods
    func configure(_ result: Result) {
        let text = NSMutableAttributedString(
            string: result.amountPerPerson.currencyFormatt,
            attributes: [.font : ThemeFont.bold(ofSize: 48)]
        )
        text.addAttributes([.font : ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 1))
        self.amountPerPersonLabel.attributedText = text
        self.totalBill.configure(result.totalBill)
        self.totalTip.configure(result.totalTip)
    }
}



