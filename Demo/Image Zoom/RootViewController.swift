import UIKit
import ZoomyView

class RootViewController: UIViewController {

	let image = UIImage(named: "patches")
	let imageView = UIImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = image

		view.backgroundColor = .systemYellow

		let zoomyVC = ZoomyViewController(zoomedView: imageView)

		view.addSubview(zoomyVC.view)
		zoomyVC.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.leadingAnchor.constraint(equalTo: zoomyVC.view.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: zoomyVC.view.trailingAnchor),
			view.bottomAnchor.constraint(equalTo: zoomyVC.view.bottomAnchor),
			view.topAnchor.constraint(equalTo: zoomyVC.view.topAnchor),
		])
		addChild(zoomyVC)
		zoomyVC.didMove(toParent: self)
	}
}
