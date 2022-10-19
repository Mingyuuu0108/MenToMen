import UIKit
import Then
import SnapKit

fileprivate let url = URL(string: "\(API)/post/submit")

class AddVC: UIViewController, ConstraintRelatableTarget {
    
    private let contentTextField = UITextView().then {
//        $0.placeholder = " 멘토에게 부탁할 내용을 입력하세요."
        $0.font = UIFont(name:"Pretendard-Regular" , size: 22.0)
        $0.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        $0.layer.cornerRadius = 20
    }
    private let addPostButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.2549, green: 0.3608, blue: 0.949, alpha: 1.0)
        $0.setTitle("멘토 요청하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16.0)
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 20.0
        $0.addTarget(self, action: #selector(TabAddPostButton), for: .touchUpInside)
    }
    
    @objc func TabAddPostButton() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setUp()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setUp() {
        
        [
            addPostButton,
            contentTextField
            
        ].forEach{ self.view.addSubview($0) }
        
        contentTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.left.equalToSuperview().offset(14)
            $0.right.equalToSuperview().offset(-14)
            $0.bottom.equalTo(contentTextField.snp.top).offset(100)
        }
        
        addPostButton.snp.makeConstraints {
            $0.top.equalTo(addPostButton.snp.bottom).offset(-80)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

private extension AddVC {
    
    func setupNavigationBar() {
        let backButtonImage = UIImage(systemName: "chevron.backward")!
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: backButtonImage.size.width, height: backButtonImage.size.height))
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(TabBackButton), for: .touchUpInside)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.title = "글쓰기"
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
