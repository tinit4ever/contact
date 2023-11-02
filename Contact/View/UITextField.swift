//
//  UITextField.swift
//  Contact
//
//  Created by tinit on 01/11/2023.
//

import UIKit

//extension UITextField {
//    func underline() {
//        let border = CALayer()
//        let borderWidth = CGFloat(1.0)
//        border.borderColor = UIColor.black.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
//
//        border.borderWidth = borderWidth
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
//
//        let attributedString = NSAttributedString(string: self.text ?? "", attributes: [
//            NSAttributedString.Key.foregroundColor: UIColor.black,
//            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
//        ])
//
//        self.attributedText = attributedString
//    }
//}
extension UITextField {
    func underline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)

        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


