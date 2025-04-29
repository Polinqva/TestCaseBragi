//
//  MainTabBarController.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 29.04.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let moviesVC = MoviesViewController()
        let tvShowsVC = TVShowsViewController()
        
        moviesVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        tvShowsVC.tabBarItem = UITabBarItem(title: "TV Shows", image: UIImage(systemName: "tv"), tag: 1)
        
        let moviesNav = UINavigationController(rootViewController: moviesVC)
        let tvShowsNav = UINavigationController(rootViewController: tvShowsVC)
        
        viewControllers = [moviesNav, tvShowsNav]
        
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .white
    }
}
