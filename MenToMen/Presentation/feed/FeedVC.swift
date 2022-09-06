//
//  feedVC.swift
//  MenToMen
//
//  Created by 이민규 on 2022/08/29.
//

import UIKit
import SnapKit
import Then

class FeedVC:UIViewController, UITableViewDelegate {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(40) }
        
        return tableView
        
    }()
    
    var userData: [UserData] = []
    let tagImages = ["iOS", "Server","ADOS","Web","Design","iOS", "Server","ADOS","Web","Design"]
    let userNames = ["이민규", "김종윤","이지민","이서코","이재건","이민규", "김종윤","이지민","이서코","이재건"]
    let contents = ["swift Snapkit으로 테이블뷰의 셀 레이아웃을 대신 짜 줄 사람 구해요.. 너무 어렵네요.",
                    "아 디자인 하기 싫다~~ 몬스터나 빨아야지~~ 야 이민규 홈마트 가자 오늘 점심 편의점야무지다~",
                    "안드로이드 한번 배워보고 싶은데 첫 걸음을 도와주실 선배님을 구하지 않습니다.",
                    "예아 바닐라 JS도와주실 선배님을 찾습니다ㅠㅠ 급합니다",
                    "안뇽~~예아 바닐라 JS도와주실 선배님을 찾습니다ㅠㅠ 급합니다",
                    "swift Snapkit으로 테이블뷰의 셀 레이아웃을 대신 짜 줄 사람 구해요.. 너무 어렵네요.",
                    "아 디자인 하기 싫다~~ 몬스터나 빨아야지~~ 야 이민규 홈마트 가자 오늘 점심 편의점야무지다~",
                    "안드로이드 한번 배워보고 싶은데 첫 걸음을 도와주실 선배님을 구하지 않습니다.",
                    "예아 바닐라 JS도와주실 선배님을 찾습니다ㅠㅠ 급합니다",
                    "안뇽~~예아 바닐라 JS도와주실 선배님을 찾습니다ㅠㅠ 급합니다"
    ]

    
    func makeData() {
        let len = tagImages.count
        
        for i in 0 ... (len - 1) {
            userData.append(UserData.init(
                tagImage: UIImage(named: tagImages[i])!,
                userName: userNames[i],
                content: contents[i]
            ))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
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

extension FeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.tagImage.image = userData[indexPath.row].tagImage ?? UIImage(named: "default")
        cell.userName.text = userData[indexPath.row].userName ?? ""
        cell.content.text = userData[indexPath.row].content ?? ""

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
