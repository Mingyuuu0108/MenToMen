import UIKit
import Then
import SnapKit
import WebKit

class SignInVC: UIViewController {
    // MARK: - 로그인화면
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "MTMLogo1")
    }
    
    private let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.tintColor = .systemBackground
        $0.placeholder = "아이디를 입력해주세요!"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.autocapitalizationType = .none
    }
    
    private let pwTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.tintColor = .systemBackground
        $0.placeholder = "비밀번호를 입력해주세요!"
        $0.isSecureTextEntry = true
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let signInButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.2549, green: 0.3608, blue: 0.949, alpha: 1.0)
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 5.0
        $0.addTarget(self, action: #selector(TabSignInButton), for: .touchUpInside)
    }
    
    private let signUpButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.4196, green: 0.498, blue: 0.949, alpha: 0.5)
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 5.0
        $0.addTarget(self, action: #selector(tabSignUpButton), for: .touchUpInside)
    }
    
    @objc func TabSignInButton() {
        
        let id = idTextField.text
        let pw = pwTextField.text
        print(id, pw)
    }
    
    @objc func tabSignUpButton() {
        let rootVC = UIViewController()
        let VC = UINavigationController(rootViewController: rootVC)
        present(VC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            logoImageView,
            textFieldSV,
            signInButton,
            signUpButton,
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
        
        self.signUpButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(5.0)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
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

