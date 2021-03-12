import UIKit
import VectorExtor

class ViewController: UIViewController {

	var lastSize: CGSize = .zero
	let scrollView = UIScrollView()
	let imageView = UIImageView()
	var image: UIImage?

	override func loadView() {
		self.view = scrollView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		image = UIImage(named: "zhara")
		imageView.image = image

		scrollView.addSubview(imageView)

		scrollView.backgroundColor = .systemPink
		scrollView.maximumZoomScale = 3
		scrollView.delegate = self

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTappedImage))
		tapGesture.numberOfTapsRequired = 2
		imageView.addGestureRecognizer(tapGesture)
		imageView.isUserInteractionEnabled = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let image = image {
			setupMinZoom(for: image.size)
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		// detect device rotation
		super.traitCollectionDidChange(previousTraitCollection)

		if let image = image {
			setupMinZoom(for: image.size)
		}
	}

	private func setupMinZoom(for imageSize: CGSize) {
		let minScales = view.bounds.size / imageSize
		let minScale = min(minScales.width, minScales.height)

		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale

		let scaledSize = imageSize * minScale
		let newImageFrame = CGRect(origin: .zero, size: scaledSize)
		imageView.frame = newImageFrame

		centerImage()
	}

	private func centerImage() {
		let imageViewSize = imageView.frame.size
		let scrollViewSize = view.frame.size

		let paddings = (scrollViewSize - imageViewSize) / 2

		let horizPadding = max(paddings.width, 0)
		let vertPadding = max(paddings.height, 0)

		scrollView.contentInset = UIEdgeInsets(horizontal: horizPadding, vertical: vertPadding)
	}

	@objc private func doubleTappedImage(_ sender: UITapGestureRecognizer) {
		if scrollView.zoomScale == scrollView.minimumZoomScale {
			let zoomRect = zoomRectangle(scale: scrollView.maximumZoomScale, center: sender.location(in: sender.view))
			scrollView.zoom(to: zoomRect, animated: true)
		} else {
			scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
		}
	}

	private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
		let zoomSize = imageView.frame.size / scale
		let zoomOrigin = center - (center * scrollView.zoomScale)

		return CGRect(origin: zoomOrigin, size: zoomSize)
	}
}


extension ViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		centerImage()
	}
}


