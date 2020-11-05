//
//  ViewDelegate.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit.UIView

protocol ViewDelegate: AnyObject {
    /// Typically used by the VC to set targets for the buttons
    /// - Parameter target: button target, normally the calling VC
    /// - Parameter action: button action
    /// - Parameter for: ui event for the action
    /// - Parameter id: id of the button, normally defined as an enum in the view
    func setButtonTarget(
        _ target: Any?,
        action: Selector,
        for controlEvents: UIControl.Event,
        id buttonId: UInt32)
    
    /// Used by the VC to enable or disable landscape constraints
    /// Normally, called from viewWillTransitionToSize(::)
    /// - Parameter isLandscape: true if landscape, false if portrait
    func activateLandscapeConstraints(_ isLandscape: Bool)
    
    /// Used by the VC to retrieve one of the views subview
    /// It is a more performant alternative to viewWithTag
    /// The ID is normally defined as an enum in the view.
    /// - Parameter viewId: ID of the view
    /// - Returns UIView?: a subview if found, nil otherwise
    func viewWithTag(_ viewId: UInt32) -> UIView?
}


