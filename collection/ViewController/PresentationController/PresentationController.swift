//
//  PresentationController.swift
//  collection
//
//  Created by 张晖 on 2022/5/26.
//

import UIKit
import CloudKit

class PresentationController: UIPresentationController,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    var presentationWrappingView :UIView?
    var dimmingView:UIView?
    let CORNER_RADIUS:CGFloat = 16.0
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
//        presentedViewController.transitioningDelegate = self
    }
    
    override var presentedView: UIView?{
        return self.presentationWrappingView
    }
    
    override func presentationTransitionWillBegin() {
        let presentedViewControllerView = super.presentedView
        let presentationWrapperView = UIView.init(frame: self.frameOfPresentedViewInContainerView)
        presentationWrapperView.layer.shadowRadius = 13.0
        presentationWrapperView.layer.shadowOpacity = 0.44
        presentationWrapperView.layer.shadowOffset = CGSize.init(width: 0, height: -6)
        presentationWrapperView.layer.shadowPath = UIBezierPath(rect: presentationWrapperView.bounds).cgPath
        self.presentationWrappingView = presentationWrapperView
        
        let presentationRoundedCornerView = UIView.init(frame: presentationWrapperView.bounds.inset(by: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)))
        presentationRoundedCornerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentationRoundedCornerView.layer.cornerRadius = CORNER_RADIUS
        presentationRoundedCornerView.layer.masksToBounds = true
        
        let presentedViewControllerWrapperView = UIView.init(frame: presentationRoundedCornerView.bounds.inset(by: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)))
        presentedViewControllerWrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        presentedViewControllerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentedViewControllerView?.frame = presentedViewControllerWrapperView.bounds;
        presentedViewControllerWrapperView.addSubview(presentedViewControllerView!)
        // Add presentedViewControllerWrapperView -> presentationRoundedCornerView.
        presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
        
        // Add presentationRoundedCornerView -> presentationWrapperView.
        presentationWrapperView.addSubview(presentationRoundedCornerView)
        
        let dimmingView = UIView.init(frame: self.containerView!.bounds)
        dimmingView.backgroundColor = .black
        dimmingView.isOpaque = false
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dimmingViewTapped(_:)))
        dimmingView.addGestureRecognizer(tap)
//            dimmingView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dimmingViewTapped(_:))))
        self.dimmingView = dimmingView;
        self.containerView!.addSubview(dimmingView)
        
        // Get the transition coordinator for the presentation so we can
        // fade in the dimmingView alongside the presentation animation.
        let transitionCoordinator:UIViewControllerTransitionCoordinator = self.presentingViewController.transitionCoordinator!
        self.dimmingView?.alpha = 0
        transitionCoordinator.animate(alongsideTransition: { context in
            self.dimmingView?.alpha = 0.5
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let transitionCoordinator:UIViewControllerTransitionCoordinator = self.presentingViewController.transitionCoordinator!
        transitionCoordinator.animate(alongsideTransition: { context in
            self.dimmingView?.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed == true {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if  container === self.presentedViewController{
            self.containerView?.setNeedsLayout()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === self.presentedViewController {
            return container.preferredContentSize
        }else{
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect{
        let containerViewBounds = self.containerView?.bounds
        let presentedViewContentSize = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerViewBounds!.size)

        var presentedViewControllerFrame = containerViewBounds
        presentedViewControllerFrame?.size.height = presentedViewContentSize.height;
        presentedViewControllerFrame?.origin.y = containerViewBounds!.maxY - presentedViewContentSize.height
        return presentedViewControllerFrame!
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.dimmingView?.frame = self.containerView?.bounds ?? CGRect.init(x: 0, y: 0, width: 0, height: 0)
        self.presentationWrappingView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated == true ? 0.35 : 0
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        let toViewController = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
        
        let toView = (transitionContext.view(forKey: .to))
        
        let fromView = transitionContext.view(forKey: .from)
        
        let isPresenting = (fromViewController === self.presentingViewController)
        
        _ = transitionContext.initialFrame(for: fromViewController!)
        
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController!)
        // This will be CGRectZero.
        var toViewInitialFrame = transitionContext.initialFrame(for: toViewController!)

        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController!)
        
        containerView.addSubview(toView ?? UIView())
        
        if isPresenting {
            toViewInitialFrame.origin = CGPoint.init(x: containerView.bounds.minX, y: containerView.bounds.maxY)
            toViewInitialFrame.size = toViewFinalFrame.size
            toView?.frame = toViewInitialFrame
        }else{
//            fromViewFinalFrame = (fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height))
            fromViewFinalFrame = fromView?.frame.offsetBy(dx: 0, dy: fromView?.frame.height ?? 0) ?? CGRect.init(x: 0, y: 0, width: 0, height: 0)
        }
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration) {
            if(isPresenting){
                toView?.frame = toViewFinalFrame
            }else{
                fromView?.frame = fromViewFinalFrame
            }
        } completion: { finished in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }

    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    @objc func dimmingViewTapped(_ sender:UITapGestureRecognizer){
        self.presentingViewController .dismiss(animated: true)
    }
    
    
}
