import UIKit
import Then
import SnapKit
import Alamofire
import CryptoKit

class SignInVC: UIViewController {

    var invalidMessage: String = ""
    var request: Bool = false
    var success: Bool = false
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "MTMLogo1")
    }
    
    private let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.tintColor = .systemBackground
        $0.placeholder = " ID를 입력해주세요!"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.autocapitalizationType = .none
        $0.borderStyle = .roundedRect
    }
    
    private let pwTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.tintColor = .systemBackground
        $0.placeholder = " 비밀번호를 입력해주세요! "
        $0.isSecureTextEntry = true
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.borderStyle = .roundedRect
    }
    
    private let signInButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.2549, green: 0.3608, blue: 0.949, alpha: 1.0)
        $0.setTitle("Dauth로 로그인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 9.0
        $0.addTarget(self, action: #selector(TabSignInButton), for: .touchUpInside)
    }
    
    private let signInGuide = UILabel().then {
        $0.text = "회원가입없이 도담계정으로 바로 로그인 해보세요!"
        $0.alpha = 0.52
        $0.font = .systemFont(ofSize: 12.0, weight: .light)
        $0.sizeToFit()
    }
    
    func toggleFailure(_ messageType: Int) {
        invalidMessage = messageType == 1 ? "ID 또는 비밀번호가 틀렸습니다" : "서버에 연결할 수 없습니다"
    }
    
    @objc func TabSignInButton() {
        
        let id = idTextField.text!
        let pw = pwTextField.text!
        print(id, pw)
        
        request = true
        AF.request("https://dauth.b1nd.com/api/auth/login",
                   method: .post,
                   parameters: ["id": id, "pw":
                                    SHA512.hash(data: pw.data(using: .utf8)!)
                    .compactMap{ String(format: "%02x", $0) }.joined(),"clientId":
                                    "39bc523458c14eb987b7b16175426a31a9f105b7f5814f1f9eca7d454bd23c73",
                                "redirectUrl": "http://localhost:3000/callback",
                                "state": "null"
                               ],
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"]
        ) { $0.timeoutInterval = 10 }
            .validate()
            .responseData { response in
                print(response)
                checkResponse(response)
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    guard let result = try? decoder.decode(CodeData.self, from: value) else { return }
                    let code = result.data.location.components(separatedBy: ["=", "&"])[1]
                    print(code)
                    AF.request("\(API)/auth/code",
                               method: .post,
                               parameters: ["code": code],
                               encoding: JSONEncoding.default,
                               headers: ["Content-Type": "application/json"]
                    ) { $0.timeoutInterval = 5 }
                        .validate()
                        .responseData { response in
                            switch response.result {
                            case .success:
                                guard let value = response.value else { return }
                                guard let result = try? decoder.decode(LoginData.self, from: value) else { return }
                                try? saveToken(result.data.accessToken, "accessToken")
                                try? saveToken(result.data.refreshToken, "refreshToken")
                                self.success = true
                                
                                if(self.success == true) {
                                    print("로그인 성공!")
                                    let VC = TabBarController()
                                    VC.modalPresentationStyle = .fullScreen
                                    self.present(VC, animated: true, completion: nil)
                                }
                            case .failure:
                                self.toggleFailure(0)
                            }
                        }
                case .failure(let error):
                    print("에러 \(error)")
                    self.errorAlert()
                    
                }
            }
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "실패", message: "알맞지 않은 ID, 비밀번호 입니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setup()
        
    }
    
    func setup() {
        
        let frame = self.view.safeAreaLayoutGuide.layoutFrame
                
        let textFieldSV = UIStackView(arrangedSubviews: [idTextField, pwTextField])
        textFieldSV.axis = .vertical
        textFieldSV.spacing = 10.0
        textFieldSV.distribution = .fillEqually
        textFieldSV.alignment = .center
        
        [
            signInGuide,
            logoImageView,
            textFieldSV,
            signInButton
        ].forEach{ self.view.addSubview($0) }
        
        logoImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(240)
            $0.leading.equalToSuperview().offset(140)
            $0.trailing.equalToSuperview().inset(140)
            $0.bottom.equalTo(idTextField.snp.top).offset(-35)
        }
        
        textFieldSV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
        }
        
        signInGuide.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signInButton.snp.bottom).offset(8)
        }
        
        self.signInButton.snp.makeConstraints {
            $0.width.equalTo(frame.width/1.75)
            $0.top.equalTo(textFieldSV.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
        }
        
        self.idTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        self.pwTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    
}

extension UITextField {
    func underlined(viewSize: CGFloat, color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height + 10, width: viewSize - 48, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
    }
}
