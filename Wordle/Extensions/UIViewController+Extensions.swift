//
//  UIViewController+Extensions.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 13/02/2024.
//

import UIKit

extension UIViewController {
    func presentSuccessResultView(currentAnswer: String) {
        let secondaryLabelText = "Congratulations! You've guessed the correct answer which was \n\(currentAnswer)\n Let's play more! 🎉"
        let mutableSecondaryLabelText = NSMutableAttributedString(string: secondaryLabelText)
        mutableSecondaryLabelText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18, weight: .bold), range: NSRange(location: 62, length: 5))
        mutableSecondaryLabelText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 62, length: 5))
        let resultVC = ResultViewController(titleLabelText: "SUCCESS! 🥳",
                                            secondaryLabelText: mutableSecondaryLabelText,
                                            retryButtonTitle: "Try Again!",
                                            image: "checkmark.circle.fill",
                                            imageColor: .appGreen!)
        resultVC.modalPresentationStyle = .overFullScreen
        resultVC.modalTransitionStyle = .crossDissolve
        self.present(resultVC, animated: true)
    }

    func presentFailResultView(currentAnswer: String) {
        let secondaryLabelText = "Unfortunately, the correct answer was \n\(currentAnswer)\nBetter luck next time! 🤞"
        let mutableSecondaryLabelText = NSMutableAttributedString(string: secondaryLabelText)
        mutableSecondaryLabelText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18, weight: .bold), range: NSRange(location: 39, length: 5))
        mutableSecondaryLabelText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 39, length: 5))
        let resultVC = ResultViewController(titleLabelText: "NO LUCK THIS TIME 😞",
                                            secondaryLabelText: mutableSecondaryLabelText,
                                            retryButtonTitle: "Try Again!",
                                            image: "xmark.circle.fill",
                                            imageColor: .appRed!)
        resultVC.modalPresentationStyle = .overFullScreen
        resultVC.modalTransitionStyle = .crossDissolve
        self.present(resultVC, animated: true)
    }
}
