//
//  NavigationTransition.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 25.08.2024.
//

import UIKit

// MARK: -- ImageTransitionAnimator
class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: TimeInterval
    var isPresenting: Bool
    var originFrame: CGRect
    var image: UIImage
    var targetFrame: CGRect

    init(duration: TimeInterval = 0.8, isPresenting: Bool = true, originFrame: CGRect, image: UIImage, targetFrame: CGRect) {
        self.duration = duration
        self.isPresenting = isPresenting
        self.originFrame = originFrame
        self.image = image
        self.targetFrame = targetFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let toViewController = transitionContext.viewController(forKey: .to)
        else { return }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)

        let snapshot = UIImageView(image: image)
        snapshot.contentMode = .scaleAspectFit
        snapshot.frame = isPresenting ? originFrame : finalFrame
        containerView.addSubview(toView)
        containerView.addSubview(snapshot)

        toView.alpha = 0.01
        toView.layoutIfNeeded()

        UIView.animate(withDuration: duration, animations: {
            snapshot.frame = self.isPresenting ? self.targetFrame : self.originFrame
            toView.alpha = 1
        }, completion: { _ in
            fromView.alpha = 1 // fromView'ı tekrar görünür hale getiriyoruz.
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

// MARK: -- CustomNavigationControllerDelegate
class CustomNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    var originFrame: CGRect = .zero
    var targetFrame: CGRect = .zero
    var image: UIImage?
    var isBasket = false
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
    
        if isBasket {
            return nil
        }

        guard let image = image else { return nil }
        
        let isPresenting = (operation == .push)
        
        return ImageTransitionAnimator(
            duration: 0.4,
            isPresenting: isPresenting,
            originFrame: originFrame,
            image: image,
            targetFrame: targetFrame
        )
    }
}
