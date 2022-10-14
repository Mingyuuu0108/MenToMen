import UIKit
import SnapKit
import Then

class CustomCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    let tagImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let userName = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    let userInfo = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 18, weight: .light)
    }
    
    let content = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 15, weight: .light)
        $0.numberOfLines = 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16.0, left: 16, bottom: 16, right: 16))

        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15)
        layer.cornerRadius = 8
        layer.borderWidth = 0.25
        
        autoLayout()
    }
    
    private func autoLayout() {
        
        [
            tagImage,
            userName,
            content
            
        ].forEach{ self.contentView.addSubview($0) }
        
        tagImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(self.snp.left).offset(34)
            $0.bottom.equalToSuperview().offset(-68)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.left.equalTo(tagImage.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-100)
        }
        
        content.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(tagImage.snp.right).offset(240)
            $0.bottom.equalToSuperview().offset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
