//
//  SceneDelegate.swift
//  MiniMarkdown
//
//  Created by Kevin Peng on 2021-03-02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: MyViewController())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

