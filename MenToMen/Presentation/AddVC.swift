import UIKit
import Then
import SnapKit

class AddVC: UIViewController {
    
    private let titleTextField = UITextField().then {
        $0.text = "멘토에게 부탁할 내용을 입력하세요."
        $0.textColor = .systemBackground
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
    }
}

private extension AddVC {
    
    func setupNavigationBar() {
        let backButtonImage = UIImage(systemName: "chevron.backward")!
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: backButtonImage.size.width, height: backButtonImage.size.height))
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(TabBackButton), for: .touchUpInside)

        
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItems = [backBarButton]
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        backButton.configuration = configuration
        
    }
    
    @objc func TabBackButton() {
        let VC = TabBarController()
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: false, completion: nil)
    }
}
