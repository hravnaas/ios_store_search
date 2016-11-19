import UIKit

// NOTE: Not currently using this as I skipped the animation tweaks
// around page 180 in tutorial. Note that the SlideOutAnimationController
// file is not even implemented.

class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
	{
		return 0.4
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
	{
		if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
		{
			let duration = transitionDuration(using: transitionContext)
			UIView.animate(
				withDuration: duration,
				animations:
				{
					fromView.alpha = 0
				},
				completion:
				{
					finished in
					transitionContext.completeTransition(finished)
				}
			)
		}
	}
}
