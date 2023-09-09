//
//  ViewController.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorViewController: UIViewController {
    // MARK: - Properties
    private let vm = CalculatorViewModel()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    // MARK: - UI
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        vStack.axis = .vertical
        vStack.spacing = 36
        return vStack
    }()
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }
    
    // MARK: - Private Methods
    private func layout() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
    private func bind() {
        let input = CalculatorViewModel.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoViewTapPublisher: logoViewTapPublisher
        )
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { [weak self] result in
            self?.resultView.configure(result)
        }.store(in: &cancellables)
        
        output.resetCalculatorPublisher.sink { [weak self] result in
            self?.billInputView.reset()
            self?.tipInputView.reset()
            self?.splitInputView.reset()
            UIView.animate(
              withDuration: 0.1,
              delay: 0,
              usingSpringWithDamping: 5.0,
              initialSpringVelocity: 0.5,
              options: .curveEaseInOut) {
                self?.logoView.transform = .init(scaleX: 1.5, y: 1.5)
              } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                  self?.logoView.transform = .identity
                }
              }
        }.store(in: &cancellables)
    }
    
    private func observe() {
        viewTapPublisher.sink { [weak self] _ in
            self?.view.endEditing(true)
        }.store(in: &cancellables)
    }
}

