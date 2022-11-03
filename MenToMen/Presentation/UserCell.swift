import UIKit
import Then

class UserCell: UITableViewCell {
    
    static let identifier = "UserCustomCell"
    
    let cellButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(TabCell), for: .touchUpInside)
    }
    
    let profileImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 32
        $0.layer.borderWidth = 0.4
    }
    
    let userInfo = UILabel().then {
        $0.text = "O학년 O반 O번"
        $0.font = UIFont(name: "Pretendard-Light", size: 16.0)
    }
    
    let userName = UILabel().then {
        $0.text = "OOO님, 환영합니다!"
        $0.font = UIFont(name: "Pretendard-Medium", size: 22.0)
    }
    
    let userEmail = UILabel().then {
        $0.text = "OOOOOOO@mail.com"
        $0.font = UIFont(name: "Pretendard-ExtraLight", size: 13.0)
    }
    
    let myPostLabel = UILabel().then {
        $0.text = "내가 올린 게시물"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20.0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    private func setup() {
        
        [
            profileImage,
            userName,
            userInfo,
            userEmail,
            myPostLabel,
            cellButton
            
        ].forEach{ self.contentView.addSubview($0) }
        
        cellButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(6)
            $0.right.equalToSuperview().offset(-6)
            $0.bottom.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(18)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalTo(profileImage.snp.left).offset(64)
            $0.bottom.equalTo(profileImage.snp.top).offset(64)
        }
        
        userInfo.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(18)
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
