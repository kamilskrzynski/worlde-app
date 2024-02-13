//
//  EnterButton.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 16/01/2024.
//

import UIKit

class EnterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = .systemGray3
        setTitle("ENTER", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
    }
}
