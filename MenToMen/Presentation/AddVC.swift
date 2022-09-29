import UIKit
import Then
import SnapKit

class AddVC: UIViewController, ConstraintRelatableTarget {
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "멘토에게 부탁할 내용을 입력하세요."
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 20
    }
    
    private let addPostButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.2549, green: 0.3608, blue: 0.949, alpha: 1.0)
        $0.setTitle("멘토 요청하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.textAlignment = .center
        $0.addTarget(self, action: #selector(TabAddPostButton), for: .touchUpInside)
    }
    
    @objc func TabAddPostButton() {
        
        if(successSignIn == true) {
            print("게시물 업로드 성공!")
            let VC = TabBarController()
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "실패", message: "로그인 후 이용가능", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
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
            titleTextField
            
        ].forEach{ self.view.addSubview($0) }
        
        titleTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(100)
            $0.bottom.equalToSuperview().offset(-100)
        }

        addPostButton.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
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
