//
//  SceneDelegate.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: Router?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        
        window = UIWindow(windowScene: scene)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        router = Router(navigationController: navigationController)
    }
}

