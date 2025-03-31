//
//  Constants.swift
//  hwInst
//
//  Created by Артём Горовой on 25.01.25.
//

import UIKit
import SnapKit
final class ViewController: UIViewController {
    
    private var imageManager: ImageManagerProtocol = ImageManager()
    private var imageItems: [ImageItem] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#C9E3F2")
        return collectionView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#C9E3F2")
        setupUI()
        loadSavedImages()
        navigationItem.hidesBackButton = true
    }
    
    private func loadSavedImages() {
        let savedImageURLs = imageManager.getSavedImageURLs()
        imageItems = savedImageURLs.compactMap { url -> ImageItem? in
            guard let creationDate = imageManager.getImageCreationDate(url) else {
                return nil
            }
            return ImageItem(url: url, date: creationDate)
        }
        collectionView.reloadData()
    }
    
    private func setupUI() {
        // Back Button
        view.addSubview(backButton)
        backButton.addAction(UIAction { _ in
            self.backButtonTapped()
        }, for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        // Collection View
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let imageItem = imageItems[indexPath.item]
        cell.configure(with: imageItem.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageItem = imageItems[indexPath.item]
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: selectedImageItem.url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let fullScreenVC = FullScreenImageViewController(image: image, date: selectedImageItem.date)
                    self.present(fullScreenVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 50) / 4
        return CGSize(width: width, height: width)
    }
}

