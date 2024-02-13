//
//  UIView+Extensions.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 12/02/2024.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
