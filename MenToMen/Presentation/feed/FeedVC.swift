//
//  feedVC.swift
//  MenToMen
//
//  Created by 이민규 on 2022/08/29.
//

import UIKit
import SnapKit
import Then

class FeedVC:UIViewController {
    
    let testArr = ["a", "b", "c", "d", "a", "b", "c", "d"]
    let tableView = UITableView()

    func attribute() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setup() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    }

    extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = testArr[indexPath.row]
                
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attribute()
        setup()
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
