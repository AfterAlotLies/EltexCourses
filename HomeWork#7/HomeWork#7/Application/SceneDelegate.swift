//
//  SceneDelegate.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let rootController = NavigationController()
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        self.window = window
    }
}

