//
//  SplitInputView.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    // MARK: - Properties
    private var cancellable = Set<AnyCancellable>()
    private let splitSubject = CurrentValueSubject<Int, Never>(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        splitSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: - UI
    private let headerView : HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = self.buildSplitButtons("-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        button.addCornerRadius()
        button.tapPublisher.flatMap { [unowned self] _ in
            Just((splitSubject.value == 1 ? 1 : splitSubject.value - 1))
        }
        .assign(to: \.value, on: splitSubject)
        .store(in: &cancellable)
        return button
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = self.buildSplitButtons("+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.addCornerRadius()
        button.tapPublisher.flatMap { [weak self] _ in
            Just((self?.splitSubject.value)! + 1)
        }
        .assign(to: \.value, on: splitSubject)
        .store(in: &cancellable)
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20), backgroundColor: .white)
    }()

    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            increaseButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func layout() {
        [headerView, hStackView].forEach(addSubview(_:))
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [increaseButton, decrementButton].forEach { button in
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
    
    private func observe() {
        splitSubject.sink { [weak self] value in
            self?.quantityLabel.text = String(value)
        }
        .store(in: &cancellable)
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
    
    // MARK: - Public Methods
    func reset() {
        splitSubject.send(1)
    }
}
