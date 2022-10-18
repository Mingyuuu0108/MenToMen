import UIKit
import Then
import SnapKit
import Alamofire

class ProfileVC: UIViewController {
    
    var datas:[ProfileData] = []
    private let profileImage = UIImageView().then {
        $0.layer.cornerRadius = 40.0
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }
    
    private let userName = UILabel().then {
        $0.text = "test님, 환영합니다!"
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
    }
    
    private let userInfo = UILabel().then {
        $0.text = "grade학년 room반 number번"
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
    }
    
    private let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.backgroundColor = .black
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .light)
        $0.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func logout() {
        let VC = SignInVC()
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParsingJSON()
    }
    
    private func ParsingJSON() {
        
        AF.request("\(API)/user/my",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    guard let result = try? decoder.decode(ProfileData.self, from: value) else { return }

                    AF.request("\(API)/user/post",
                               method: .get,
                               encoding: URLEncoding.default,
                               headers: ["Content-Type": "application/json"],
                               interceptor: Requester()
                    ) { $0.timeoutInterval = 10 }
                        .validate()
                        .responseData { (response) in
                            print(checkStatus(response))
                            switch response.result {
                            case .success:
                                guard let value = response.value else { return }
                                guard let result = try? decoder.decode(PostData.self, from: value) else { return }
//                                self.datas = result.data
                            case .failure(let error):
                                print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                            }
                        }
                case .failure(let error):
                    print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
                }
            }
    }
    
    func setup() {
                
        [
            profileImage,
            userName,
            userInfo,
            logoutButton
            
        ].forEach{ self.view.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(80)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(10)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

private extension ProfileVC {
    
    func setupNavigationBar() {
        
        let logoImage = UIImage.init(named: "MTMLogo2")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:120,height:50.0)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 120)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 50.0)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem = imageItem
        
        let bellButtonImage = UIImage(systemName: "bell")!
        let bellButton = UIButton(frame: CGRect(x: 0, y: 0, width: bellButtonImage.size.width, height: bellButtonImage.size.height))
        bellButton.setImage(bellButtonImage, for: .normal)
        bellButton.addTarget(self, action: #selector(TabBellButton), for: .touchUpInside)
        
        let bellBarButton = UIBarButtonItem(customView: bellButton)
        
        self.navigationItem.rightBarButtonItems = [bellBarButton]
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        
        bellButton.configuration = configuration
        
    }
    
    @objc func TabBellButton() {
        print("알람")
    }
}
