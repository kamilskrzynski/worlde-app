//
//  ResultViewController.swift
//  Wordle
//
//  Created by Kamil Skrzyński on 12/02/2024.
//

import UIKit

protocol ResultViewControllerDelegate: AnyObject {
    func resetCurrentAnswer()
}

class ResultViewController: UIViewController {

    var image: String?
    var titleLabelText: String?
    var secondaryLabelText: NSAttributedString?
    var retryButtonTitle: String?
    var imageColor: UIColor!

    weak var delegate: ResultViewControllerDelegate?

    init(titleLabelText: String,
         secondaryLabelText: NSAttributedString,
         retryButtonTitle: String,
         image: String,
         imageColor: UIColor,
         delegate: ResultViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabelText = titleLabelText
        self.secondaryLabelText = secondaryLabelText
        self.retryButtonTitle = retryButtonTitle
        self.image = image
        self.imageColor = imageColor
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let containerView: UIView = {
        let containerView = UIView()      
        containerView.backgroundColor = .appColor
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        return containerView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let retryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(resetCurrentAnswer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        view.addSubviews(containerView, titleLabel, imageView, secondaryLabel, retryButton)
        setUpContraints()
        configure()
    }

    func configure() {
        let unwrappedImage = image ?? "xmark"
        imageView.image = UIImage(systemName: unwrappedImage)
        imageView.tintColor = imageColor
        titleLabel.text = titleLabelText ?? ""
        secondaryLabel.attributedText = secondaryLabelText ?? NSAttributedString(string: "")
        retryButton.setTitle(retryButtonTitle, for: .normal)
    }

    func setUpContraints() {
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 420),
            containerView.widthAnchor.constraint(equalToConstant: 320),

            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),

            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),

            secondaryLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 100),
            secondaryLabel.widthAnchor.constraint(equalToConstant: 300),

            retryButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            retryButton.widthAnchor.constraint(equalToConstant: 110)
        ])
    }

    @objc func resetCurrentAnswer() {
        delegate?.resetCurrentAnswer()
        dismiss(animated: true)
    }
}
