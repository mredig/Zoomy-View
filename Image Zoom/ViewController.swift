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

	override func loadView() {
		self.view = scrollView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

//		let imageURL = Bundle.main.url(forResource: "zhara", withExtension: "jpg")!
//		let data = try! Data(contentsOf: imageURL)
		let image = UIImage(named: "zhara")
		imageView.image = image
		imageView.contentMode = .center

		imageView.frame = CGRect(origin: .zero, size: image?.size ?? .zero)
		imageView.backgroundColor = .systemBlue

		imageView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(imageView)
		scrollView.constrain(subview: imageView)
		
		scrollView.backgroundColor = .systemPink
		scrollView.maximumZoomScale = 10
		scrollView.minimumZoomScale = 1
		scrollView.delegate = self


		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			print(self)
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		guard scrollView.bounds.size != lastSize else { return }
		defer { lastSize = scrollView.bounds.size }
		imageView.center = scrollView.center
	}
}


extension ViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}
}


