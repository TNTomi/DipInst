//
//  FullScreenViewController.swift
//  hwInst
//
//  Created by Артём Горовой on 31.03.25.
//
import UIKit
import SnapKit

final class FullScreenImageViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let dateLabel = UILabel()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    init(image: UIImage, date: Date) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
        dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }

    private func setupUI() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .white
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.layer.cornerRadius = 10
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        view.addSubview(dateLabel)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(closeButton.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}


