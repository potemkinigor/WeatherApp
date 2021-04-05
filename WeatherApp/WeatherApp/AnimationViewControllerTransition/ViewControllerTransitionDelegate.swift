//
//  ViewControllerTransitionDelegate.swift
//  WeatherApp
//
//  Created by User on 03.04.2021.
//

import Foundation
import UIKit

protocol ViewControllerTransitionDelegateProtocol: NSObject, UIViewControllerTransitioningDelegate  {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
}

final class ViewControllerTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, ViewControllerTransitionDelegateProtocol {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let simplePresent = ViewControllerPresentAnimatedTransitioning()
        return simplePresent
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let simpleDismiss = ViewControllerDismissAnimatedTransitioning()
        return simpleDismiss
    }
}
