//
//  ViewControllerDismissAnimatedTransitioning.swift
//  WeatherApp
//
//  Created by User on 03.04.2021.
//

import Foundation
import UIKit
final class ViewControllerDismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceVC = transitionContext.viewController(forKey: .from) else { return }
        guard let targetVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerViewFrame = transitionContext.containerView.frame
        
        let sourceViewTargetFrame = CGRect(x: 0,
                                           y: containerViewFrame.height,
                                           width: sourceVC.view.frame.width,
                                           height: sourceVC.view.frame.height)
        
        let destinationViewTargetFrame = sourceVC.view.frame
        
        targetVC.view.frame = CGRect(x: 0,
                                        y: -containerViewFrame.height,
                                        width: sourceVC.view.frame.width,
                                        height: sourceVC.view.frame.height)
        
        transitionContext.containerView.addSubview(targetVC.view)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                     animations: {
                        sourceVC.view.frame = sourceViewTargetFrame
                        targetVC.view.frame = destinationViewTargetFrame
                     }) { finished in
                            sourceVC.removeFromParent()
                            transitionContext.completeTransition(finished)
                        }
    }
    
}
