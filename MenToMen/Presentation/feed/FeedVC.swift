import UIKit
import SnapKit
import Then

//피드 뷰컨트롤러
class FeedVC:UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(40) }
        
        return tableView
        
    }()
    
    //더미데이터
    var userData: [UserData] = []
    let tagImages = ["iOS"]
    let userNames = ["이민규"]
    let contents = ["swift Snapkit으로 테이블뷰의 셀 레이아웃을 대신 짜 줄 사람 구해요.. 너무 어렵네요."]
    
    
    func makeData() {
        userData.append(UserData.init(
            tagImage: UIImage(named: tagImages[0])!,
            userName: userNames[0],
            content: contents[0]
        ))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        setupNavigationBar()
        setupView()
        
        makeData()
        configure()
        addSubView()
        autoLayout()
    }
    private func configure() {
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    private func setupView() {tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.selectionStyle = .none
        cell.tagImage.image = userData[indexPath.row].tagImage ?? UIImage(named: "default")
        cell.userName.text = userData[indexPath.row].userName ?? ""
        cell.content.text = userData[indexPath.row].content ?? ""
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
