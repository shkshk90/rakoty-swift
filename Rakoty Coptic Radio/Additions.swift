//
//  Additions.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit.UIScreen
import UIKit.UIViewController
import UIKit.UIImage
import os.log

// MARK: - OSLog Extension
extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// Main app log object
    static let rakodaLog       = OSLog(subsystem: subsystem, category: "RakodaApp")
    enum rakoda {
        /// Convenience function that logs using rakodaLog object.
        /// - Parameter type: type of logging
        /// - Parameter message: the static string
        /// - Parameter args: the arguments, if any
        static func log(type: OSLogType = .default, _ message: StaticString, _ args: CVarArg...) {
            switch type {
            case .error: fallthrough
            case .fault: fallthrough
            case .info:
                os_log(message, log: rakodaLog, type: type, args)
                
            default:
                #if DEBUG
                os_log(message, log: rakodaLog, type: type, args)
                #else
                break
                #endif
            }
           
        }
    }
}


// MARK: - UIScreen Extensions
extension UIScreen {
    static let screenWidth  = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize   = UIScreen.main.bounds.size
}


// MARK: - UIViewController Extensions
extension UIViewController {
    
    /// Stamps a sub view over the view controllers main view.
    /// - Parameter subview: The subview which will be stamped to the main view
    func stampSubview(subview: UIView) {
        view.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: view.topAnchor),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subview.leftAnchor.constraint(equalTo: view.leftAnchor),
            subview.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
}


// MARK: - UIImage Extensions
extension UIImage {
    /// Returns an image with rounded corners, better for Performance than clipoToBounds()
    /// - Parameter cornerRadius: The radius of the corner of the image
    /// - Returns: Image with round corners
    func roundedImage(_ cornerRadius: CGFloat = 50.0) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            os_log("Failed to create rounded image from image.",
                   log: OSLog.rakodaLog,
                   type: .fault)
            return self
        }
        
        return result
    }
}


// MARK: - UIApplication Extensions
extension UIApplication {
    static func isCurrentInterfaceLandscape() -> Bool {
        guard let firstWindow = UIApplication.shared.windows.first else {
            return false
        }
        
        guard let windowScene = firstWindow.windowScene else {
            return false
        }
        
        switch (windowScene.interfaceOrientation) {
        case .landscapeLeft: fallthrough
        case .landscapeRight:
            return true
            
        default:
            return false
        }
    }
}

/*
 
 
 
 
 
 
 extension DateFormatter {
 static let rakotyTimeString = "hh:mm a"
 static let rakotyDateString = "dd.MM.yyyy"
 static func customFormatter(withFormat fmt: String, atCairo isCairo: Bool = true) -> DateFormatter {
 let temp = DateFormatter()
 
 temp.locale = Locale(identifier: "en_US_POSIX")
 temp.dateFormat = fmt
 temp.timeZone = isCairo ? TimeZone(identifier: "Africa/Cairo") : TimeZone.current
 //        temp.timeZone = TimeZone(secondsFromGMT:
 //            isCairo ?  :
 //                TimeZone.current.secondsFromGMT())
 
 
 
 return temp
 }
 }
 */
