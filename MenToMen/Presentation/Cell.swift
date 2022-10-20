import UIKit
import SnapKit
import Then

class Cell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    let tagImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let userName = UILabel().then {
        $0.text = "OOO"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Regular", size: 18.0)
    }
    
    let userInfo = UILabel().then {
        $0.text = "O학년 O반 O번"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-ExtraLight", size: 12.0)
    }
    
    let content = UILabel().then {
        $0.text = "내용"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Light", size: 15.0)
        $0.numberOfLines = 2
    }
    
    let postImage = UIImageView().then {
        $0.layer.cornerRadius = 4.0
        $0.backgroundColor = .systemBackground
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layer.cornerRadius = 20
    }
    
    private func setup() {

        [
            tagImage,
            userName,
            userInfo,
            content,
            postImage
            
        ].forEach{ self.contentView.addSubview($0) }
        
        tagImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(tagImage.snp.left).offset(28)
            $0.bottom.equalTo(tagImage.snp.top).offset(40)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.left.equalTo(tagImage.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-100)
        }
        
        userInfo.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(2)
            $0.left.equalTo(tagImage.snp.right).offset(10)
        }
        
        content.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(tagImage.snp.right).offset(240)
            $0.bottom.equalToSuperview().offset(12)
        }
        
        postImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.equalTo(content.snp.right).offset(16)
            $0.right.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
