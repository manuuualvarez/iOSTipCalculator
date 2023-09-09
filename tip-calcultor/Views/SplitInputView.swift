//
//  SplitInputView.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import UIKit

class SplitInputView: UIView {
    
    private let headerView : HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = self.buildSplitButtons("-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        button.addCornerRadius()
        return button
    }()
    
    
    private lazy var addButton: UIButton = {
        let button = self.buildSplitButtons("+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.addCornerRadius()
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20), backgroundColor: .white)
    }()

    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            addButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, hStackView].forEach(addSubview(_:))
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [addButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.centerY.equalTo(hStackView.snp.centerY)
            make.leading.equalToSuperview()
            make.width.equalTo(68)
            make.trailing.equalTo(hStackView.snp.leading).offset(-24)
        }
        
    }
    
    private func buildSplitButtons(_ title: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addRoundedCorners(corners: corners)
        return button
        
    }
}
