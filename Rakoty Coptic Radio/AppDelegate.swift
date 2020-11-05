//
//  AppDelegate.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
         AVAudioSession *const sharedSession = [AVAudioSession sharedInstance];
         if (!sharedSession)
             return YES;
         
         NSError *err;
         BOOL res = [sharedSession
                      setCategory:AVAudioSessionCategoryPlayback
                             mode:AVAudioSessionModeMoviePlayback
                          options:AVAudioSessionCategoryOptionMixWithOthers |             AVAudioSessionCategoryOptionDuckOthers
                            error:&err];
         if (!res)
             os_log_error(sbs_log_general_g,
                          "Failed to set AVAudioSession's category. Error: %s",
                          [[err localizedDescription] UTF8String]);
         
         
         res = [sharedSession setActive:YES error:&err];
         if (!res)
             os_log_error(sbs_log_general_g,
                          "Failed to set AVAudioSession's to active. Error: %s",
                          [[err localizedDescription] UTF8String]);
         
         os_log_debug(sbs_log_general_g, "App delegate did finish launch.");
         */
        
        /* In the other app delegate
         
         var window: UIWindow?
             

             func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                 // Override point for customization after application launch.
                 try? AVAudioSession.sharedInstance()
                     .setCategory(AVAudioSession.Category.playback,
                                  mode: AVAudioSession.Mode.moviePlayback,
                                  //options: [.allowAirPlay, .mixWithOthers]
                                  options: []
                 )
                 try? AVAudioSession.sharedInstance().setActive(true)
                 
                 guard let ver = Float(UIDevice.current.systemVersion), ver < 13.0  else { return true }
                 
                 let window = UIWindow(frame: UIScreen.main.bounds)
                 window.rootViewController = TabBarViewController()
                 
                 self.window = window
                 window.makeKeyAndVisible()
                 
                 
                 return true
             }
         
         */
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

