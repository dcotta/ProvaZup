//
//  AppDelegate.swift
//  ProvaZup
//
//  Created by Diego on 19/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tbc : UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        // instancia o UITabBarController a partir do Main.xib criado
        tbc = (Bundle.main.loadNibNamed("Main", owner: nil, options: nil)?[0] as! UITabBarController)
        // atribui como rootViewControoler da aplicação o UITabBarController
        self.window?.rootViewController = tbc
        //carrega o realm
        let realm = try! Realm()
        //busca os filmes salvos
        let filmDb = realm.objects(FilmDetails.self)
        //verifica se existe filmes salvos, caso exista vai para a viewcontroller de meus filmes, caso contrario vai para a tela de pesquisa
        if filmDb.count == 0 {
            self.tbc?.selectedIndex = 1
        }
        
        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

