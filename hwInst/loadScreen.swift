
//
//  LoadScreen.swift
//  hwInst
//
//  Created by Артём Горовой on 9.01.25.
//
//
//  LoadScreen.swift
//  hwInst
//
//  Created by Артём Горовой on 9.01.25.
//

import UIKit
import SnapKit

final class LoadScreen: UIViewController, UITextFieldDelegate {

    private let containerView = UIView()
    private var chosenImage: UIImage?

    private let addImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 50
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let screen: UIImageView = {
        let screen = UIImageView()
        screen.contentMode = .scaleAspectFit
        return screen
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.isHidden = true
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private var imageManager: ImageManagerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupUI()
        imageManager = ImageManager()
        navigationItem.hidesBackButton = true
    }

    private func setupUI() {
        view.addSubview(containerView)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        containerView.addGestureRecognizer(recognizer)
        containerView.backgroundColor = UIColor(hex: "#C9E3F2")
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerView.addSubview(screen)
        screen.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(150)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        containerView.addSubview(addImageButton)
        addImageButton.addAction(UIAction { _ in
            self.showImagePicker()
        }, for: .touchUpInside)
        addImageButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        containerView.addSubview(saveButton)
        saveButton.addAction(UIAction { _ in
            self.saveAndReturn()
        }, for: .touchUpInside)
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(screen.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        view.addSubview(backButton)
        backButton.addAction(UIAction { _ in
            self.navigateBack()
        }, for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func showImagePicker() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in self.openImagePicker(with: .camera) })
        alert.addAction(UIAlertAction(title: "Gallery", style: .default) { _ in self.openImagePicker(with: .photoLibrary) })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func openImagePicker(with source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            let alert = UIAlertController(title: "Error", message: "Source is unavailable.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    private func saveAndReturn() {
        guard let chosenImage = chosenImage else { return }
        if let imageURL = saveImageAndGetURL(image: chosenImage) {
            imageManager.addImage(imageURL)
        }
        
        if let navigationController = navigationController {
            let viewController = ViewController()
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    private func saveImageAndGetURL(image: UIImage) -> URL? {
        if let data = image.jpegData(compressionQuality: 1.0),
           let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = directory.appendingPathComponent(UUID().uuidString + ".jpg")
            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("Error saving image: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension LoadScreen: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        chosenImage = image
        screen.image = image
        addImageButton.isHidden = true
        saveButton.isHidden = false
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


