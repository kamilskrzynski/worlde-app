//
//  MainViewController.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 23/01/2023.
//

import UIKit

protocol ViewControllerDelegate {
    func resetCurrentAnswer()
}

class MainViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        resetCurrentAnswer()
    }

    var currentAnswer: String = "HONEY"

    var correctLetters: [Character] = []
    var guessedLetters: [Character] = []
    var wrongLetters: [Character] = []

    var wordsToCheck: [[Character]] = []

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
            gameBoardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),

            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

    func checkIfGuessed() {
        let currentAnswerAsArray = Array(currentAnswer)
        for i in 0..<currentGameboard.count {
            for j in 0..<currentGameboard[i].count {
                guard currentGameboard[i].count == 5, currentGameboard[i][j] != nil else { return }
                let wordToCheck = currentGameboard[i].compactMap { $0 }
                DispatchQueue.main.async {
                    if wordToCheck == currentAnswerAsArray {
                        self.presentSuccessResultView(currentAnswer: self.currentAnswer, delegate: self)
                    } else if self.currentGameboard[5][4] != nil && wordToCheck != currentAnswerAsArray {
                        self.presentFailResultView(currentAnswer: self.currentAnswer, delegate: self)
                    }
                }
            }
        }
    }
}

extension MainViewController {

    func getAnswers() -> Answers? {
        if let url = Bundle.main.url(forResource: "Answers", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Answers.self, from: data)
                return jsonData
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func resetCurrentAnswer() {
            let answers = getAnswers()!
            currentAnswer = answers.names.randomElement()?.uppercased() ?? "CLOUD"
    }
}

extension MainViewController: KeyboardViewControllerDelegate {
    func keyboardVC(_vc: KeyboardViewController, didTapKey letter: Character) {

        var isDone = false

        for i in 0..<currentGameboard.count {
            for j in 0..<currentGameboard[i].count {
                if currentGameboard[i][j] == nil {
                    currentGameboard[i][j] = letter
                    isDone = true
                    DispatchQueue.main.async {
                        self.gameBoardVC.reloadData()
                        self.keyboardVC.reloadData()
                    }
                    break
                }
            }
            if isDone {
                break
            }
        }
        DispatchQueue.main.async {
            self.gameBoardVC.reloadData()
            self.keyboardVC.reloadData()
        }
    }
}

extension MainViewController: KeyBoardViewControllerDatasource {
    var keyboardLetters: [[Character?]] {
        return letters
    }

    func keyboardColor(at indexPath: IndexPath) -> UIColor? {
        // TODO: Fix a bug when sometimes some letters are not checked to be marked as guessed/correct/wrong like A/C/N

        guard let letter = keyboardLetters[indexPath.section][indexPath.row] else {
            return .systemGray3
        }

        if guessedLetters.contains(letter) && !correctLetters.contains(letter) {
            return .appYellow
        }

        if correctLetters.contains(letter) {
            return .appGreen
        }

        if wrongLetters.contains(letter) {
            return .systemGray6
        }

        return .systemGray3
    }
}

extension MainViewController: GameboardViewControllerDatasource {
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

        self.checkIfGuessed()

        if answerAsArray[indexPath.row] == letter {
            if !correctLetters.contains(letter) {
                correctLetters.append(letter)
            }
            return .appGreen
        }

        // if answerAsArray.contains(letter) && !correctLetters.contains(letter) {
        if answerAsArray.contains(letter) {
            if !guessedLetters.contains(letter) {
                guessedLetters.append(letter)
            }
            return .appYellow
        }

        if answerAsArray[indexPath.row] != letter && !guessedLetters.contains(letter) && !correctLetters.contains(letter) {
            if !wrongLetters.contains(letter) {
                wrongLetters.append(letter)
            }
            return .systemGray6
        }

        return .systemGray6
    }
}

extension MainViewController: ResultViewControllerDelegate {
    func resetGameboard() {
        correctLetters = []
        guessedLetters = []
        wrongLetters = []
        currentGameboard = Array(
            repeating: Array(
                repeating: nil,
                count: 5
            ),
            count: 6
        )
        self.gameBoardVC.reloadData()
        self.keyboardVC.reloadData()
        resetCurrentAnswer()
    }
}
