import UIKit
import Then

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {

            super.viewDidLoad()

            view.backgroundColor = .systemBackground

            let homeViewController = UINavigationController(rootViewController: FeedVC())
            homeViewController.tabBarItem.title = "홈화면"
            homeViewController.tabBarItem.image = UIImage(systemName: "house")
            homeViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")

            let addViewController = UINavigationController(rootViewController: AddVC())
            addViewController.tabBarItem.title = "추가"
            addViewController.tabBarItem.image = UIImage(systemName: "plus.circle")
            addViewController.tabBarItem.selectedImage = UIImage(systemName: "plus.circle.fill")

            let profileViewController = UINavigationController(rootViewController: SignInVC())
            profileViewController.tabBarItem.title = "마이페이지"
            profileViewController.tabBarItem.image = UIImage(systemName: "person")
            profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

            viewControllers = [homeViewController, addViewController, profileViewController]
        }
}
