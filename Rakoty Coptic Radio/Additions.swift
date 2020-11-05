//
//  Additions.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import Foundation
// import os.log
/*
 
 @implementation UIImage (SBSRoundedImage)

 - (UIImage *)roundedImage
 {
     CGRect const rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
     UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0);
     
     [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:50] addClip];
     [self drawInRect:rect];
     
     return UIGraphicsGetImageFromCurrentImageContext();
 }
 
 @protocol SBSViewDelegate
 @required
 - (void)setButtonTarget:(nullable id)aTarget action:(nullable SEL)aAction forButtonId:(const NSInteger)aId;
 - (void)activateLandscapeConstraints:(BOOL)hasLandscapeLayout;
 - (UIView *__nullable)viewFromId:(const NSInteger)aViewId;
 @end
 
 
 extension OSLog {
     private static var subsystem = Bundle.main.bundleIdentifier!
     static let scheduleLog       = OSLog(subsystem: subsystem, category: "Schedule")
     static let htmlLog           = OSLog(subsystem: subsystem, category: "HTMLParser")
 }

 extension UIScreen {
    static let screenWidth  = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize   = UIScreen.main.bounds.size
 }

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
