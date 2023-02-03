//
//  KeyboardCell.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 24/01/2023.
//

import UIKit

class KeyboardCell: UICollectionViewCell {
    static let identifier = "KeyboardCell"

    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    func configure(with letter: Character) {
        label.text = String(letter).uppercased()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
