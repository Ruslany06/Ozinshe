//
//  TabBarController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 06.11.2023.
//

import UIKit
import SnapKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabs()
    }
    
    func setupTabs() {
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let favoritesVC = FavoritesViewController()
        let friendsVC = FriendsViewController()
        let profileVC = ProfileViewController()
        
//        let tabItemAppearance = UITabBarItem.appearance()
//           tabItemAppearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -20)
        homeVC.title = nil
        searchVC.title = nil
        favoritesVC.title = nil
        friendsVC.title = nil
        profileVC.title = nil
        
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Home"), selectedImage: UIImage(named: "HomeSelected"))
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Search"), selectedImage: UIImage(named: "SearchSelected"))
        favoritesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Favorites"), selectedImage: UIImage(named: "FavoritesSelected"))
        friendsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Friends"), selectedImage: UIImage(named:  "FriendsSelected"))
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Profile"), selectedImage: UIImage(named: "ProfileSelected"))
        
        let profileNavController = UINavigationController(rootViewController: profileVC)
        let favoriteNavController = UINavigationController(rootViewController: favoritesVC)
        let searchNavController = UINavigationController(rootViewController: searchVC)
        let homeNavController = UINavigationController(rootViewController: homeVC)
        
        setViewControllers([homeNavController, searchNavController, favoriteNavController, friendsVC, profileNavController], animated: true)
    }
    
    
}
