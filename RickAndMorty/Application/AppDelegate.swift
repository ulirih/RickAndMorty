//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let dbManager = CoreDataManager.shared
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navConrolller = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navConrolller)
        appCoordinator!.start()
        
        window?.rootViewController = navConrolller
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NetworkState.shared.startMonitoring()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        try? dbManager.save()
        NetworkState.shared.stopMonitoring()
    }
}

