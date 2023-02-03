//
//  ViewController.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 23/01/2023.
//

import UIKit

class ViewController: UIViewController {

    let currentAnswer = "LATER"

    var currentGameboard: [[Character?]] = Array(
        repeating: Array(
            repeating: nil,
            count: 5
        ),
        count: 6
    )

    var letters: [[Character]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Z", "X", "C", "V", "B", "N", "M"]
    ]

    let gameBoardVC = GameBoardViewController()
    let keyboardVC = KeyboardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .appColor
        addViews()
        addConstraints()
    }

    func addViews() {
        addChild(keyboardVC)
        keyboardVC.delegate = self
        keyboardVC.datasource = self
        keyboardVC.didMove(toParent: self)
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)

        addChild(gameBoardVC)
        gameBoardVC.datasource = self
        gameBoardVC.didMove(toParent: self)
        gameBoardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoardVC.view)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            gameBoardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameBoardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameBoardVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            gameBoardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            gameBoardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),

            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           // keyboardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
}

extension ViewController: KeyboardViewControllerDelegate {
    func keyboardVC(_vc: KeyboardViewController, didTapKey letter: Character) {

        var isDone = false

        for i in 0..<currentGameboard.count {
            for j in 0..<currentGameboard[i].count {
                if currentGameboard[i][j] == nil {
                    currentGameboard[i][j] = letter
                    isDone = true
                    gameBoardVC.reloadData()
                    break
                }
            }
            if isDone {
                break
            }
        }
        gameBoardVC.reloadData()
    }
}

extension ViewController: KeyBoardViewControllerDatasource {
    var keyboardLetters: [[Character?]] {
        return letters
    }

    func keyboardColor(at indexPath: IndexPath) -> UIColor? {
//        let answerAsArray = Array(currentAnswer)
//
//        if answerAsArray[indexPath.row] == letters[indexPath.section][indexPath.row] {
//            return .appGreen
//        }
//
//        if answerAsArray.contains(letters[indexPath.section][indexPath.row]) {
//            return .appYellow
//        }

        return .systemGray3
    }
}

extension ViewController: GameboardViewControllerDatasource {
    var gameboard: [[Character?]] {
        return currentGameboard
    }

    func gameboardColor(at indexPath: IndexPath) -> UIColor? {

        // Wait and show colors after whole line filled with letters
        let count = currentGameboard[indexPath.section].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }

        guard let letter = currentGameboard[indexPath.section][indexPath.row] else {
            return nil
        }

        let answerAsArray = Array(currentAnswer)
        if answerAsArray[indexPath.row] == letter {
            return .appGreen
        }

        if answerAsArray.contains(letter) {
            return .appYellow
        }

        return .systemGray3
    }
}
