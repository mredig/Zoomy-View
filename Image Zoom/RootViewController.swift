import UIKit

class RootViewController: UIViewController {

	let image = UIImage(named: "patches")
	let imageView = UIImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = image

		view.backgroundColor = .systemYellow

		let zoomyVC = ZoomyViewController(zoomedView: imageView)

		view.addSubview(zoomyVC.view)
		view.constrain(subview: zoomyVC.view)
		addChild(zoomyVC)
		zoomyVC.didMove(toParent: self)
	}
}
