//
//  Buttons.swift
//  hwInst
//
//  Created by Артём Горовой on 2.12.24.
//
import UIKit
final class Buttons {
    
    static let forwardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forward", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = UIColor(hex:"#3399cc")
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 50
        return button
    }()
    
    static let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 50
        return button
    }()
    
    static let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 50
        return button
    }()
    
    static let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textAlignment = .center
        return button
    }()
    static let likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("❤️", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
}
