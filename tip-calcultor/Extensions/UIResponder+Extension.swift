//
//  UIResponder+Extension.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import Foundation
import UIKit


extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
