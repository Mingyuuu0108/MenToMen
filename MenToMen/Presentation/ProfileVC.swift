import UIKit
import Then
import SnapKit
import Alamofire
import Kingfisher

fileprivate let url = URL(string: "\(API)/post/read-all")

class ProfileVC: UIViewController, UITableViewDelegate {
    
    var datas:[ProfileDatas] = []
    var data:[PostDatas] = []
    
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
    
    private let myPostLabel = UILabel().then {
        $0.text = "내가 올린 게시물"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20.0)
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 100
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
                                self.data = result.data
                                self.tableView.reloadData()
                                
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
            myPostLabel,
            tableView
            
        ].forEach{ self.view.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalTo(profileImage.snp.left).offset(64)
            $0.bottom.equalTo(profileImage.snp.top).offset(64)
        }
        
        userInfo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.left.equalTo(profileImage.snp.right).offset(14)
            $0.bottom.equalTo(userInfo.snp.top).offset(20)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalTo(userInfo.snp.bottom).offset(2)
            $0.left.equalTo(profileImage.snp.right).offset(14)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(userName.snp.top).offset(20)
        }
        
        userEmail.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(4)
            $0.left.equalTo(profileImage.snp.right).offset(14)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(userEmail.snp.top).offset(18)
        }
        
        myPostLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(myPostLabel.snp.top).offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(myPostLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func logout() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: {_ in
            let VC = SignInVC()
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil) }))
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: {_ in print("") }))
        present(alert, animated: true)
    }
}


extension ProfileVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        cell.selectionStyle = .none
        
        let grade = self.data[indexPath.row].stdInfo.grade
        let room = self.data[indexPath.row].stdInfo.room
        let number = self.data[indexPath.row].stdInfo.number
        
        cell.userName.text = self.data[indexPath.row].userName
        cell.userInfo.text = "\(grade!)학년 \(room!)반 \(number!)번"
        cell.content.text = self.data[indexPath.row].content
        
        if self.data[indexPath.row].imgUrls != nil {
            let url = URL(string: self.data[indexPath.row].imgUrls![0])
            cell.postImage.kf.setImage(with: url)
        } else {
            cell.postImage.image = UIImage(named: "")
        }
        
        switch self.data[indexPath.row].tag {
        case "IOS":
            cell.tagImage.image = UIImage(named: "iOS")
        case "WEB":
            cell.tagImage.image = UIImage(named: "Web")
        case "SERVER":
            cell.tagImage.image = UIImage(named: "Server")
        case "ANDROID":
            cell.tagImage.image = UIImage(named: "Android")
        default:
            cell.tagImage.image = UIImage(named: "Design")
        }
        
        return cell
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
        
        let bellButtonImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")!
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
