import UIKit
import Then
import SnapKit
import Alamofire

class AddVC: UIViewController {
    
    var tag:String = ""
    var data:PostDatas?
    
    private let contentTextField = UITextView().then {
        $0.font = UIFont(name:"Pretendard-Regular" , size: 22.0)
        $0.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        $0.layer.cornerRadius = 20
    }
    
    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBackground
        $0.distribution = .fillEqually
    }
    
    private lazy var designButton = UIButton().then {
        $0.setImage(UIImage(named: "B1"), for: .normal)
        $0.addTarget(self, action: #selector(tabDesignButton), for: .touchUpInside)
    }
    @objc func tabDesignButton() { tag = "DESIGN" }
    
    private lazy var webButton = UIButton().then {
        $0.setImage(UIImage(named: "B2"), for: .normal)
        $0.addTarget(self, action: #selector(tabWebButton), for: .touchUpInside)
    }
    @objc func tabWebButton() { tag = "WEB" }
    
    private lazy var serverButton = UIButton().then {
        $0.setImage(UIImage(named: "B3"), for: .normal)
        $0.addTarget(self, action: #selector(tabServerButton), for: .touchUpInside)
    }
    @objc func tabServerButton() { tag = "SERVER" }
    
    private lazy var androidButton = UIButton().then {
        $0.setImage(UIImage(named: "B4"), for: .normal)
        $0.addTarget(self, action: #selector(tabAndroidButton), for: .touchUpInside)
    }
    @objc func tabAndroidButton() { tag = "ANDROID" }
    
    private lazy var iOSButton = UIButton().then {
        $0.setImage(UIImage(named: "B5"), for: .normal)
        $0.addTarget(self, action: #selector(tabiOSButton), for: .touchUpInside)
    }
    @objc func tabiOSButton() { tag = "IOS" }
    
    
    private lazy var addPostButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.2549, green: 0.3608, blue: 0.949, alpha: 1.0)
        $0.setTitle("멘토 요청하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16.0)
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 4.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(TabAddPostButton), for: .touchUpInside)
    }
    
    func submit(_ params: [String: Any]) {
        AF.request("\(API)/post/\(data == nil ? "submit" : "update")",
                   method: data == nil ? .post : .patch,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { response in
                print(params)
                checkResponse(response)
                switch response.result {
                case .success:
                    print("POST 성공")
                    self.postAlert()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func postAlert() {
        let alert = UIAlertController(title: "성공!", message: "멘토 요청이 성공적으로 되었습니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default ,handler: {_ in
            let VC = TabBarController()
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil) }))
        present(alert, animated: true)
    }
    
    func noTagAlert() {
        let alert = UIAlertController(title: "실패!", message: "태그를 선택하지 않았습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func noContentsAlert() {
        let alert = UIAlertController(title: "실패!", message: "글을 작성하지 않았습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @objc func TabAddPostButton() {
        var reqParam: [String: Any] = ["content": contentTextField.text!, "imgUrls": []]
        reqParam["tag"] = tag
        if data != nil {
            reqParam["postId"] = data!.postId
        }
        if contentTextField.text! != "" && tag != "" {
            submit(reqParam)
        } else if contentTextField.text! == "" {
            self.noContentsAlert()
        } else if tag == "" {
            self.noTagAlert()
        }
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            addPostButton.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            addPostButton.frame.origin.y += keyboardHeight
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardNotification()
        setupNavigationBar()
        setUp()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setUp() {
        
        [
            addPostButton,
            stackView,
            contentTextField
            
        ].forEach{ self.view.addSubview($0) }
        
        
        stackView.addArrangedSubview(designButton)
        stackView.addArrangedSubview(webButton)
        stackView.addArrangedSubview(androidButton)
        stackView.addArrangedSubview(serverButton)
        stackView.addArrangedSubview(iOSButton)
        
        contentTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.left.equalToSuperview().offset(14)
            $0.right.equalToSuperview().offset(-14)
            $0.bottom.equalTo(contentTextField.snp.top).offset(100)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(contentTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(4)
            $0.right.equalToSuperview().offset(-4)
            $0.bottom.equalTo(stackView.snp.top).offset(22)
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
