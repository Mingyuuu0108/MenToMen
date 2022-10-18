import UIKit
import Then
import SnapKit
import Alamofire
import Kingfisher

class ProfileVC: UIViewController {
    
    var datas:[ProfileDatas] = []
    
    private let profileImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 32
        $0.layer.borderWidth = 0.4
        $0.backgroundColor = .systemBackground
    }
    
    private let userInfo = UILabel().then {
        $0.text = "O학년 O반 O번"
        $0.font = UIFont(name: "Pretendard-Light", size: 16.0)
    }
    
    private let userName = UILabel().then {
        $0.text = "OOO님, 환영합니다!"
        $0.font = UIFont(name: "Pretendard-Medium", size: 22.0)
    }
    
    private let userEmail = UILabel().then {
        $0.text = "OOOOOOO@mail.com"
        $0.font = UIFont(name: "Pretendard-ExtraLight", size: 13.0)
    }
    
    
    private let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .light)
        $0.titleLabel?.textAlignment = .center
        $0.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
//    private lazy var tableView = UITableView().then {
//        $0.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
//        $0.delegate = self
//        $0.dataSource = self
//        $0.rowHeight = 100
//    }
    
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
                    
                    let grade = result.data.stdInfo.grade
                    let room = result.data.stdInfo.room
                    let number = result.data.stdInfo.number
                    
                    self.userName.text = "\(result.data.name)님, 환영합니다!"
                    self.userInfo.text = "\(grade!)학년 \(room!)반 \(number!)번"
                    self.userEmail.text = "\(result.data.email)"
                    
                    if result.data.profileImage != nil {
                        let url = URL(string: result.data.profileImage!)
                        self.profileImage.kf.setImage(with: url)
                    } else {
                        self.profileImage.image = UIImage(named: "profile")
                    }
                    
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
            userEmail,
            logoutButton
            
        ].forEach{ self.view.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalTo(profileImage.snp.left).offset(64)
            $0.bottom.equalTo(profileImage.snp.top).offset(64)
        }
        
        userInfo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.left.equalTo(profileImage.snp.right).offset(14)
            $0.bottom.equalTo(userInfo.snp.top).offset(20)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalTo(userInfo.snp.bottom).offset(4)
            $0.left.equalTo(profileImage.snp.right).offset(14)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(userName.snp.top).offset(20)
        }
        
        userEmail.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(4)
            $0.left.equalTo(profileImage.snp.right).offset(14)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(userEmail.snp.top).offset(14)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(userEmail.snp.bottom).offset(10)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(logoutButton.snp.top).offset(20)
        }
    }
    
    @objc func logout() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: {_ in
            let VC = SignInVC()
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil) }))
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: {_ in print("") }))
        present(alert, animated: true)
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
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: {_ in
            let VC = SignInVC()
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil) }))
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: {_ in print("") }))
        present(alert, animated: true)
    }
}
