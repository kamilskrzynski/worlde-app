//
//  KeyboardViewController.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 23/01/2023.
//

import UIKit

protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardVC(_vc: KeyboardViewController, didTapKey letter: Character)
}

protocol KeyBoardViewControllerDatasource: AnyObject {
    var keyboardLetters: [[Character?]] { get }
    func keyboardColor(at indexPath: IndexPath) -> UIColor?
}

class KeyboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    weak var datasource: KeyBoardViewControllerDatasource?
    weak var delegate: KeyboardViewControllerDelegate?

    let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 4
        collectionViewLayout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyboardCell.self, forCellWithReuseIdentifier: KeyboardCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyboardCell.identifier, for: indexPath) as? KeyboardCell else {
            fatalError()
        }
        let letters = datasource?.keyboardLetters ?? []
        let letter = letters[indexPath.section][indexPath.row] ?? "."
        cell.configure(with: letter)
        cell.layer.cornerRadius = 5
        cell.backgroundColor = datasource?.keyboardColor(at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let letters = datasource?.keyboardLetters ?? []
        return letters[section].count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 20
        let interItemSpacing: CGFloat = 10*4
        let size: CGFloat = (collectionView.frame.size.width-margin-interItemSpacing-40)/10

        return CGSize(
            width: size,
            height: size*1.5
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemsInSection: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
        let margin: CGFloat = 20
        let interItemSpacing: CGFloat = 10*4
        let size: CGFloat = (collectionView.frame.size.width-margin-interItemSpacing-40)/10
        let inset: CGFloat = (collectionView.frame.size.width - (size * itemsInSection) - (itemsInSection * 4))/2

        return UIEdgeInsets(
            top: 4,
            left: inset,
            bottom: 4,
            right: inset
        )
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {let letters = datasource?.keyboardLetters ?? []
        return letters.count
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let letters = datasource?.keyboardLetters ?? []
        let letter = letters[indexPath.section][indexPath.row] ?? "A"
        delegate?.keyboardVC(_vc: self, didTapKey: letter)
    }
}
