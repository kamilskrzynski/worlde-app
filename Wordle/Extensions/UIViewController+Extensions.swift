//
//  UIViewController+Extensions.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 13/02/2024.
//

import UIKit

extension UIViewController {

    func presentResultView(titleLabelText: String,
                           secondaryLabelText: NSAttributedString,
                           retryButtonTitle: String,
                           image: String,
                           imageColor: UIColor) {
        let resultVC = ResultViewController(titleLabelText: titleLabelText, secondaryLabelText: secondaryLabelText, retryButtonTitle: retryButtonTitle, image: image, imageColor: imageColor)
        resultVC.modalPresentationStyle = .overFullScreen
        resultVC.modalTransitionStyle = .crossDissolve
        self.present(resultVC, animated: true)
    }
}
