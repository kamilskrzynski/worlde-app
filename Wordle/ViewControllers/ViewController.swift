//
//  ViewController.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 23/01/2023.
//

import UIKit

class ViewController: UIViewController {

    let gameBoardVC = GameBoardViewController()
    let keyboardVC = KeyboardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appColor")
        addViews()
        addConstraints()
    }

    func addViews() {
        addChild(gameBoardVC)
        gameBoardVC.didMove(toParent: self)
        gameBoardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoardVC.view)

        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            gameBoardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameBoardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameBoardVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            gameBoardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),

            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
}

