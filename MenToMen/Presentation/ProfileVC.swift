import UIKit

class ProfileVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        [testButton].forEach{ self.view.addSubview($0) }

        testButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(400)
            $0.bottom.equalToSuperview().offset(-400)
            $0.left.equalToSuperview().offset(80)
            $0.right.equalToSuperview().offset(-80)
        }
        
    }
    
    private let testButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.2549, green: 0.3608, blue: 0.949, alpha: 1.0)
        $0.setTitle("테스트", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 5.0
        $0.addTarget(self, action: #selector(TabTestButton), for: .touchUpInside)
    }
    
    @objc func TabTestButton() {
        
        let rootVC = SignInVC()
        let VC = UINavigationController(rootViewController: rootVC)
        self.present(VC, animated: true)
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
