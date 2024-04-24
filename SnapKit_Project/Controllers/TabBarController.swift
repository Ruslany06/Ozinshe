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
        tabBar.backgroundColor = UIColor.FFFFFF_1_C_2431
        tabBar.barTintColor = UIColor.FFFFFF_1_C_2431
        setupTabs()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setTabImages()
    }
    
    func setupTabs() {
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let favoritesVC = FavoritesViewController()
        let friendsVC = FriendsViewController()
        let profileVC = ProfileViewController()
        
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

    func setTabImages() {
        let homeSelectedImage = UIImage(named: "HomeSelected")?.withRenderingMode(.alwaysOriginal)
        let searchSelectedImage = UIImage(named: "SearchSelected")?.withRenderingMode(.alwaysOriginal)
        let favoriteSelectedImage = UIImage(named: "FavoritesSelected")?.withRenderingMode(.alwaysOriginal)
        let profileSelectedImage = UIImage(named: "ProfileSelected")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[0].selectedImage = homeSelectedImage
        tabBar.items?[1].selectedImage = searchSelectedImage
        tabBar.items?[2].selectedImage = favoriteSelectedImage
        tabBar.items?[4].selectedImage = profileSelectedImage
    }
    
}
