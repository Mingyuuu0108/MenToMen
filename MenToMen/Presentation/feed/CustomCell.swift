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
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    let content = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 0 //텍스트가 셀을 넘었을 떄 줄바꿈을 해주는 코드
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    private func addContentView() {
        
        
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15)
        layer.cornerRadius = 20
        layer.borderWidth = 1
        
        contentView.addSubview(tagImage)
        contentView.addSubview(userName)
        contentView.addSubview(content)
    }
    
    private func autoLayout() {
        
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(tagImage.snp.right).offset(10)
        }//유저 이름의 레이아웃
        
        content.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(tagImage.snp.right).offset(300)
            $0.bottom.equalToSuperview().offset(20)
        }//내용의 레이아웃
        
        NSLayoutConstraint.activate([
            tagImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tagImage.widthAnchor.constraint(equalToConstant: 36),
            tagImage.heightAnchor.constraint(equalToConstant: 54),
            tagImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
