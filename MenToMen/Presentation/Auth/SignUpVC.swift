import UIKit
import SnapKit
import Then

class SignUpVC: UIViewController {
    
    private let nameTextField = UITextField().then {
        $0.placeholder = "이름"
        $0.backgroundColor = .purple
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.borderStyle = .roundedRect
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
        $0.textColor = .label
        $0.placeholder = "비밀번호를 입력해주세요!"
        $0.isSecureTextEntry = false
        $0.autocorrectionType = .no
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }

    private let pwCheckTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.tintColor = .systemBackground
        $0.textColor = .label
        $0.placeholder = "비밀번호를 재입력해주세요!"
        $0.isSecureTextEntry = false
        $0.autocorrectionType = .no
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }

    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입하기!", for: .normal)
        $0.backgroundColor = UIColor(red: 0.2549, green: 0.3608, blue: 0.949, alpha: 1.0)
        $0.layer.cornerRadius = 5.0
        $0.titleLabel?.textAlignment = .center
        $0.addTarget(self, action: #selector(TabSignUpButton), for: .touchUpInside)
    }

    @objc func TabSignUpButton(){
        print("회원가입이 완료되었습니다!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setup()
        
    }
    
    func setup() {
        
        let nameIdTextFieldSV = UIStackView(arrangedSubviews: [nameTextField, idTextField])
        nameIdTextFieldSV.axis = .vertical
        nameIdTextFieldSV.spacing = 10.0
        nameIdTextFieldSV.distribution = .fillEqually
        nameIdTextFieldSV.alignment = .center
        
        let pwTextFieldSV = UIStackView(arrangedSubviews: [pwTextField, pwCheckTextField])
        pwTextFieldSV.axis = .vertical
        pwTextFieldSV.spacing = 10.0
        pwTextFieldSV.distribution = .fillEqually
        pwTextFieldSV.alignment = .center
        
        [
            nameIdTextFieldSV,
            pwTextFieldSV,
            signUpButton
            
        ].forEach{ self.view.addSubview($0) }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().inset(35)
        }
    }
}

