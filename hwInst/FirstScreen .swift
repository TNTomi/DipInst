import UIKit
import SnapKit

final class FirstScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.backgroundColor
        setupUI()
        navigationItem.hidesBackButton = true
    }
    
    private func setupUI() {
        let plusButton = createButton(title: "+", action: plusButtonAction)
        let nextButton = createButton(title: "→", action: nextButtonAction)
        
        view.addSubview(plusButton)
        view.addSubview(nextButton)
        
        plusButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(200)
            make.width.height.equalTo(UIConstants.buttonSize)
        }
        
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-200)
            make.width.height.equalTo(UIConstants.buttonSize)
        }
    }
    
    private func createButton(title: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 50
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }
    
    private func plusButtonAction() {
        let controller = LoadScreen()
        navigateToController(controller)
    }
    
    private func nextButtonAction() {
        let controller = ViewController()
        navigateToController(controller)
    }
    
    private func navigateToController(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    

}

