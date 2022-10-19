import UIKit
import SnapKit
import Then
import Kingfisher
import Alamofire

fileprivate let url = URL(string: "\(API)/post/read-all")

class FeedVC:UIViewController, UITableViewDelegate {
    
    var data: [PostData] = []
    var datas: [PostDatas] = []
    
    private lazy var tableView = UITableView().then {
        $0.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 100
    }
    
    func setuptableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalToSuperview()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuptableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParsingJSON()
    }
    
    private func ParsingJSON() {
        
        AF.request(url!,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json"])
        .validate()
        .responseData { (response) in
            switch response.result {
            case .success:
                print("성공!\n🔥")
                
                guard let value = response.value else { return }
                guard let result = try? decoder.decode(PostData.self, from: value) else { return }
                self.datas = result.data
                self.tableView.reloadData()
                
            case .failure(let error):
                print("실패\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}

extension FeedVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.selectionStyle = .none
        
        let grade = self.datas[indexPath.row].stdInfo.grade
        let room = self.datas[indexPath.row].stdInfo.room
        let number = self.datas[indexPath.row].stdInfo.number
        
        cell.userName.text = self.datas[indexPath.row].userName
        cell.userInfo.text = "\(grade!)학년 \(room!)반 \(number!)번"
        cell.content.text = self.datas[indexPath.row].content
        
        if self.datas[indexPath.row].imgUrls != nil {
            let url = URL(string: self.datas[indexPath.row].imgUrls![0])
            cell.postImage.kf.setImage(with: url)
        }
        
        switch self.datas[indexPath.row].tag {
        case "IOS":
            cell.tagImage.image = UIImage(named: "iOS")
        case "WEB":
            cell.tagImage.image = UIImage(named: "Web")
        case "SERVER":
            cell.tagImage.image = UIImage(named: "Server")
        case "ANDROID":
            cell.tagImage.image = UIImage(named: "Android")
        default:
            cell.tagImage.image = UIImage(named: "Design")
        }
        
        return cell
    }
}

//피드 네비게이션바 뷰
private extension FeedVC {
    
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
        
        let searchButtonImage = UIImage(systemName: "magnifyingglass")!
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: searchButtonImage.size.width, height: searchButtonImage.size.height))
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.addTarget(self, action: #selector(TabSearchButton), for: .touchUpInside)
        
        let bellBarButton = UIBarButtonItem(customView: bellButton)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.rightBarButtonItems = [bellBarButton, searchBarButton]
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        
        bellButton.configuration = configuration
        searchButton.configuration = configuration
        
    }
    
    @objc func TabBellButton() {
        print("알람")
    }
    @objc func TabSearchButton() {
        print("검색")
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
