//
//  SceneDelegate.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 1.08.2024.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    private var lastSelectedIndex: Int = 0


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController

        setupTabBarController(tabBarController: tabBarController)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        tabBarController.delegate = self

        // Notification dinleme
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDidSignIn), name: .userDidSignIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDidSignOut), name: .userDidSignOut, object: nil)
    }

    private func setupTabBarController(tabBarController: UITabBarController) {
        let firstViewController = HomeBuilder.createModule()
        let secondViewController = CategoryPageRouter.createModule()
        let thirdViewController = BasketModuleBuilder.createModule()
        let fourthViewController = FavouritesBuilder.createModule()
        let fifthViewController = getFifthViewController()

        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)
        let fifthNavigationController = UINavigationController(rootViewController: fifthViewController)

        firstNavigationController.tabBarItem = UITabBarItem(
            title: "Ana Sayfa",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        secondNavigationController.tabBarItem = UITabBarItem(
            title: "Kategoriler",
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        thirdNavigationController.tabBarItem = UITabBarItem(
            title: "Sepetim",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        fourthViewController.tabBarItem = UITabBarItem(
            title: "Favorilerim",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        fifthNavigationController.tabBarItem = UITabBarItem(
            title: "Hesabım",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        tabBarController.viewControllers = [firstNavigationController,
                                            secondNavigationController,
                                            thirdNavigationController,
                                            fourthViewController,
                                            fifthNavigationController]
    }

    private func getFifthViewController() -> UIViewController {
        if Auth.auth().currentUser != nil {
            return LoggedUserVC()
        } else {
            return GuestAccountVC()
        }
    }

    @objc private func handleUserDidSignIn() {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let updatedFifthViewController = LoggedUserVC()
            updatedFifthViewController.tabBarItem = UITabBarItem(
                title: "Hesabım",
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "person.fill")
            )
            let viewControllers = tabBarController.viewControllers
            if let fiftNavigationController = viewControllers?[4] as? UINavigationController {
                fiftNavigationController.setViewControllers([updatedFifthViewController], animated: true)
            }
            tabBarController.viewControllers = viewControllers
        }
    }

    @objc private func handleUserDidSignOut() {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let updatedFifthViewController = GuestAccountVC()
            updatedFifthViewController.tabBarItem = UITabBarItem(
                title: "Hesabım",
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "person.fill")
            )
            let viewControllers = tabBarController.viewControllers
            if let fifthNavigationController = viewControllers?[4] as? UINavigationController {
                fifthNavigationController.setViewControllers([updatedFifthViewController], animated: true)
            }
            tabBarController.viewControllers = viewControllers
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController,
           let homeViewController = navigationController.viewControllers.first as? HomeViewController {
            if lastSelectedIndex == tabBarController.selectedIndex {
                homeViewController.scrollToTop()
            }
        }

        lastSelectedIndex = tabBarController.selectedIndex
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

extension Notification.Name {
    static let userDidSignIn = Notification.Name("userDidSignIn")
    static let userDidSignOut = Notification.Name("userDidSignOut")
    static let didUpdateSearchResults = Notification.Name("didUpdateSearchResults")
}
