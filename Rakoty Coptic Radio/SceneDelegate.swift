//
//  SceneDelegate.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        /*
         if (![scene isKindOfClass:[UIWindowScene class]])
             return;
         
         UIWindowScene *const windowScene = (UIWindowScene *)scene;
         
         self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
         /*
          TODO: REPLACE THE TAB BAR CONTROLLER WITH THE NAVIGATION ONE, AND PASS THE NAVIGATION TO ROOT VC
          UINavigationController *const audioNavigationController =
          [[UINavigationController alloc] initWithRootViewController:audioVC];
          */
         self.window.rootViewController = [[SBSTabBarViewController alloc] init];
         
         [self.window makeKeyAndVisible];
         
         os_log_debug(sbs_log_general_g, "Scene delegate will connect to session.");
         */
        
        /* In the other scene delegate
         #if SBY_USE_OLD_GUI
                 print("USING SWIFTUI GUI")
                 let contentView = ContentView()

                 // Use a UIHostingController as window root view controller.
                 if let windowScene = scene as? UIWindowScene {
                     let window = UIWindow(windowScene: windowScene)
                     window.rootViewController =
                         UIHostingController(rootView: contentView
                         //.environmentObject(ScheduleData())
                     )
                     self.window = window
                     window.makeKeyAndVisible()
                 }
                 #else
                 guard let windowScene = (scene as? UIWindowScene) else { return }
         //        print("USING other GUI")
                 let window = UIWindow(windowScene: windowScene)
                 window.rootViewController = TabBarViewController()
                 
                 self.window = window
                 window.makeKeyAndVisible()
                 #endif
         */
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

