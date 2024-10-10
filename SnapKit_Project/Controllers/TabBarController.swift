//
//  TabBarController.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 06.11.2023.
//

import UIKit
import SnapKit

// MARK: CustomTabBar
class CustomTabBar: UITabBar {
    
    let customHeight: CGFloat = 88 // Укажите нужную высоту
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Устанавливаем новый фрейм для tabBar
        var tabFrame = self.frame
        tabFrame.size.height = customHeight
        tabFrame.origin.y = UIScreen.main.bounds.height - customHeight
        self.frame = tabFrame
        
        let tabBarButtons = subviews.filter { String(describing: type(of: $0)) == "UITabBarButton" }

                for tabBarButton in tabBarButtons {
                    var frame = tabBarButton.frame
                    frame.origin.y += 7.5  // Сдвигаем кнопку ниже
                    tabBarButton.frame = frame
                }
    }
}

// MARK: TabBarController
class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor.FFFFFF_1_C_2431
        tabBar.barTintColor = UIColor.FFFFFF_1_C_2431
        setupTabs()
        
        // Устанавливаем кастомный таббар
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setTabImages()
        
    }
    
    func setupTabs() {
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let favoritesVC = FavoritesViewController()
        let profileVC = ProfileViewController()
        
        homeVC.title = nil
        searchVC.title = nil
        favoritesVC.title = nil
        profileVC.title = nil
        
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Home"), selectedImage: UIImage(named: "HomeSelected"))
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Search"), selectedImage: UIImage(named: "SearchSelected"))
        favoritesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Favorites"), selectedImage: UIImage(named: "FavoritesSelected"))
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Profile"), selectedImage: UIImage(named: "ProfileSelected"))
        
        // Настройка imageInsets для корректного позиционирования
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6.5, left: 0, bottom: -6.5, right: 0)
        searchVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6.5, left: 0, bottom: -6.5, right: 0)
        favoritesVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6.5, left: 0, bottom: -6.5, right: 0)
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6.5, left: 0, bottom: -6.5, right: 0)
        
        let profileNavController = UINavigationController(rootViewController: profileVC)
        let favoriteNavController = UINavigationController(rootViewController: favoritesVC)
        let searchNavController = UINavigationController(rootViewController: searchVC)
        let homeNavController = UINavigationController(rootViewController: homeVC)
        
        setViewControllers([homeNavController, searchNavController, favoriteNavController, profileNavController], animated: true)
    }

    func setTabImages() {
        let homeSelectedImage = UIImage(named: "HomeSelected")?.withRenderingMode(.alwaysOriginal)
        let searchSelectedImage = UIImage(named: "SearchSelected")?.withRenderingMode(.alwaysOriginal)
        let favoriteSelectedImage = UIImage(named: "FavoritesSelected")?.withRenderingMode(.alwaysOriginal)
        let profileSelectedImage = UIImage(named: "ProfileSelected")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[0].selectedImage = homeSelectedImage
        tabBar.items?[1].selectedImage = searchSelectedImage
        tabBar.items?[2].selectedImage = favoriteSelectedImage
        tabBar.items?[3].selectedImage = profileSelectedImage
    }
    
}
