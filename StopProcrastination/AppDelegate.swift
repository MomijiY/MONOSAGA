//
//  AppDelegate.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2020/11/22.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    
                }
            })
        Realm.Configuration.defaultConfiguration = config
        config.deleteRealmIfMigrationNeeded = true
        UNUserNotificationCenter.current().requestAuthorization(
               options: [.alert, .sound, .badge]){
                   (granted, _) in
                   if granted{
                       UNUserNotificationCenter.current().delegate = self
                }
        }
            // Override point for customization after application launch.
        return true
    }

}

// 通知を受け取ったときの処理
extension AppDelegate: UNUserNotificationCenterDelegate {
    //when iPhone was locked or the app was closed...
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return
        }
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if  let scheduleDetailVC = storyboard.instantiateViewController(withIdentifier: "sdVC") as? DetailScheduledTableViewController,
                let tabBarController = rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController {
                navController.pushViewController(scheduleDetailVC, animated: true)
            }else if let tabBarController = rootViewController as? UITabBarController,
            let navController = tabBarController.selectedViewController as? UINavigationController{
                navController.popViewController(animated: true)
            }
        }
        completionHandler()
    }
}
