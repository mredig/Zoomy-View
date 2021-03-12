import UIKit

class RootViewController: UIViewController {

	let image = UIImage(named: "zhara")
	let imageView = UIImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = image

		view.backgroundColor = .systemYellow

		let zoomyVC = ZoomyViewController()

		view.addSubview(zoomyVC.view)
		view.constrain(subview: zoomyVC.view)
		addChild(zoomyVC)
		zoomyVC.didMove(toParent: self)
	}
}
