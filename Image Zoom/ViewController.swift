//
//  ViewController.swift
//  Image Zoom
//
//  Created by Michael Redig on 3/11/21.
//

import UIKit

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
		let minWidthScale = view.bounds.width / imageSize.width
		let minHeightScale = view.bounds.height / imageSize.height
		let minScale = min(minWidthScale, minHeightScale)

		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale

		let width = imageSize.width * minScale
		let height = imageSize.height * minScale
		let newImageFrame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
		imageView.frame = newImageFrame

		centerImage()
	}

	private func centerImage() {
		let imageViewSize = imageView.frame.size
		let scrollViewSize = view.frame.size
		let vertPadding = max((scrollViewSize.height - imageViewSize.height) / 2, 0)
		let horizPadding = max((scrollViewSize.width - imageViewSize.width) / 2, 0)

		scrollView.contentInset = UIEdgeInsets(horizontal: horizPadding, vertical: vertPadding)
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


