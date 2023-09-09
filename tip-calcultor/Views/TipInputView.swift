//
//  TipInputView.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    // MARK: - Properties
    private var cancellable = Set<AnyCancellable>()
    private let tipSubject = CurrentValueSubject<Tip, Never>(.none)
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    // MARK: - UI
    private let headerView : HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentButton: UIButton = {
        let button = self.buildTipButton(.tenPercent)
        button.tapPublisher.flatMap { Just(Tip.tenPercent)}
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var fifteenPercentButton: UIButton = {
        let button = self.buildTipButton(.fifteenPercent)
        button.tapPublisher.flatMap { Just(Tip.fifteenPercent)}
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var twentyPercentButton: UIButton = {
        let button = self.buildTipButton(.twentyPercent)
        button.tapPublisher.flatMap { Just(Tip.twentyPercent)}
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var horizontalButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentButton,
            fifteenPercentButton,
            twentyPercentButton
            
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius()
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }
        .store(in: &cancellable)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            horizontalButtonsStackView,
            customTipButton,
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Initialization
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
        [headerView, buttonsStackView].forEach(addSubview(_:))
        buttonsStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.centerY.equalTo(horizontalButtonsStackView.snp.centerY)
            make.leading.equalToSuperview()
            make.width.equalTo(68)
            make.trailing.equalTo(buttonsStackView.snp.leading).offset(-24)
        }
    }
    
    private func observe() {
        tipSubject.sink { [weak self] tip in
            self?.resetView()
            switch tip {
            case .none:
                break
            case .tenPercent:
                self?.tenPercentButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                self?.fifteenPercentButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                self?.twentyPercentButton.backgroundColor = ThemeColor.secondary
            case .custom(value: let value):
                self?.customTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(
                    string: "USD \(value)",
                    attributes: [.font : ThemeFont.bold(ofSize: 20)]
                )
                self?.customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellable)
    }
    
    private func resetView() {
        [tenPercentButton, fifteenPercentButton, twentyPercentButton, customTipButton].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font : ThemeFont.bold(ofSize: 20)]
        )
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    private func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(
                title: "Enter custom tip in USD",
                message: nil,
                preferredStyle: .alert
            )
            controller.addTextField { textfield in
                textfield.placeholder = "Make it generous!"
                textfield.keyboardType = .numberPad
                textfield.autocorrectionType = .no
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                guard let text = controller.textFields?.first?.text, let value = Int(text) else {
                    return
                }
                self?.tipSubject.send(.custom(value: value))
            }
            [okAction, cancelAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alertController, animated: true)
    }
    
    private func buildTipButton(_ tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius()
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font : ThemeFont.bold(ofSize: 20),
                .foregroundColor: UIColor.white
            ]
        )
        text.addAttributes([.font : ThemeFont.semiBold(ofSize: 14)], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
    
    // MARK: - Public Methods
    func reset() {
        tipSubject.send(.none)
    }
}


