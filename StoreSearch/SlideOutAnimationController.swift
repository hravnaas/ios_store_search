import UIKit

class SlideOutAnimationController: NSObject,
UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext:
		return 0.3 }
UIViewControllerContextTransitioning?) -> TimeInterval {
	func animateTransition(using transitionContext:
		UIViewControllerContextTransitioning) {
		if let fromView = transitionContext.view(forKey:
			UITransitionContextViewKey.from) {
			let containerView = transitionContext.containerView
			let duration = transitionDuration(using: transitionContext)
			UIView.animate(withDuration: duration, animations: {
				fromView.center.y -= containerView.bounds.size.height
				fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
			}, completion: { finished in
				transitionContext.completeTransition(finished)
			})
		} }
}