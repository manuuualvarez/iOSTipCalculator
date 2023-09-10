//
//  tip_calculatorSnapshotTest.swift
//  tip-calcultorTests
//
//  Created by Manny Alvarez on 09/09/2023.
//

import XCTest
import SnapshotTesting
@testable import tip_calcultor
    


final class tip_calculatorSnapshotTest: XCTestCase {
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func testLogoView() {
        //Given
        let size = CGSize(width: screenWidth, height: 48)
        //When
        let view = LogoView()
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testInitialResultView() {
        //Given
        let size = CGSize(width: screenWidth, height: 224)
        //When
        let view = ResultView()
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testResultViewWithValues() {
        //Given
        let size = CGSize(width: screenWidth, height: 224)
        let result = Result(amountPerPerson: 100.25, totalBill: 100, totalTip: 10.0)
        //When
        let view = ResultView()
        view.configure(result)
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testInitialBillInputView() {
        //Given
        let size = CGSize(width: screenWidth, height: 56)
        //When
        let view = BillInputView()
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testBillInputViewWithValues() {
        //Given
        let size = CGSize(width: screenWidth, height: 56)
        //When
        let view = BillInputView()
        let tf = view.allSubViewsOf(type: UITextField.self).first
        tf?.text = "500"
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testInitialTipInputView() {
        //Given
        let size = CGSize(width: screenWidth, height: 56+56+16)
        //When
        let view = TipInputView()
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testTipInputViewWithValues() {
        //Given
        let size = CGSize(width: screenWidth, height: 56+56+16)
        //When
        let view = TipInputView()
        let button = view.allSubViewsOf(type: UIButton.self).first
        button?.sendActions(for: .touchUpInside)
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testSplitInputView() {
        //Given
        let size = CGSize(width: screenWidth, height: 56)
        //When
        let view = SplitInputView()
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testSplitInputViewWithSelection() {
        //Given
        let size = CGSize(width: screenWidth, height: 56)
        //When
        let view = SplitInputView()
        let button = view.allSubViewsOf(type: UIButton.self)[1]
        button.sendActions(for: .touchUpInside)
        //Then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    
}


extension UIView {
  // https://stackoverflow.com/a/45297466/6181721
  func allSubViewsOf<T : UIView>(type : T.Type) -> [T] {
    var all = [T]()
    func getSubview(view: UIView) {
      if let aView = view as? T{
        all.append(aView)
      }
      guard view.subviews.count>0 else { return }
      view.subviews.forEach{ getSubview(view: $0) }
    }
    getSubview(view: self)
    return all
  }
}
