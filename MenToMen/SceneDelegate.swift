//
//  SceneDelegate.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let s = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: s)
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor(red: 0.1529, green: 0.2863, blue: 0.8627, alpha: 1.0)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = TabBarController()
    }
}

