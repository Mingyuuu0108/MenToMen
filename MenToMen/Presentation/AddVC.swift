import UIKit
import Then
import SnapKit

class AddVC: UIViewController {
    
    private let titleTextField = UITextField().then {
        $0.text = "게시글의 제목을 입력해주세요"
        $0.textColor = .systemBackground
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
