import UIKit
import SnapKit
import Then
import Kingfisher
import Alamofire

let url = URL(string: "http://10.80.163.83:8080/post/read-all")

//피드 뷰컨트롤러
class FeedVC:UIViewController {
    
    struct Contact: Codable {
        let userName: String
        let content: String
        let tag: String
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 100
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        addSubView()
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    private func setupView() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParsingJSON()
    }
    
    fileprivate var Posts: [Posts] = []
    
    private func ParsingJSON() {
        
        AF.request(url!,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            switch response.result{
            case .success(let data):
                
                print("성공\n🔥\n\(response)")
                let decoder = JSONDecoder()
                let result = try? decoder.decode(HomeResponse.self, from: data)

                self.Posts = result?.posts ?? []
                
                self.tableView.reloadData()
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.userName.text = "\(String(describing: self.Posts[indexPath.row].userName))"
        
        cell.content.text = "\(self.Posts[indexPath.row].content!)"
        
        if ((self.Posts[indexPath.row].tag) ==  "IOS") {
            cell.tagImage.image = UIImage(named: "iOS")
        } else if ((self.Posts[indexPath.row].tag) ==  "WEB") {
            cell.tagImage.image = UIImage(named: "Web")
        } else if ((self.Posts[indexPath.row].tag) ==  "SERVER") {
            cell.tagImage.image = UIImage(named: "Server")
        } else if ((self.Posts[indexPath.row].tag) ==  "ANDROID") {
            cell.tagImage.image = UIImage(named: "Android")
        } else {
            cell.tagImage.image = UIImage(named: "Design")
        }
        
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
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
