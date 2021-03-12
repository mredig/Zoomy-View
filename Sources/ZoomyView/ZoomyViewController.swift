import UIKit
import VectorExtor

/// The zoom calculations rely on the intrinsic content size of the passed in view. This is passively gained in a UIImageView from its UIImage.
public class ZoomyViewController: UIViewController {

	private var lastSize: CGSize = .zero
	private let scrollView = UIScrollView()
	public let zoomedView: UIView

	public var maximumZoomScale: CGFloat {
		get { scrollView.maximumZoomScale }
		set { scrollView.maximumZoomScale = newValue }
	}

	public var zoomOnDoubleTap = true

	public init(zoomedView: UIView) {
		self.zoomedView = zoomedView
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override public func loadView() {
		self.view = scrollView
	}

	override public func viewDidLoad() {
		super.viewDidLoad()

		scrollView.addSubview(zoomedView)

		scrollView.maximumZoomScale = 3
		scrollView.delegate = self

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTappedImage))
		tapGesture.numberOfTapsRequired = 2
		zoomedView.addGestureRecognizer(tapGesture)
		zoomedView.isUserInteractionEnabled = true
	}

	// update views called here to ideally be ready before presentation
	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateViews()
	}

	// failsafe. if viewwillappear call to updateviews didnt work, this should always have the correct view size
	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		updateViews()
	}

	override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		// detect device rotation
		super.traitCollectionDidChange(previousTraitCollection)

		let current = UITraitCollection.current

		let currentHor = current.horizontalSizeClass
		let currentVer = current.verticalSizeClass

		let previousHor = previousTraitCollection?.horizontalSizeClass
		let previousVer = previousTraitCollection?.verticalSizeClass

		guard [currentHor, currentVer] != [previousHor, previousVer] else { return }

		updateViews()
	}

	private func updateViews() {
		setupMinZoom(for: zoomedView.intrinsicContentSize)
	}

	private func setupMinZoom(for imageSize: CGSize) {
		let minScales = view.bounds.size / imageSize
		let minScale = min(minScales.width, minScales.height)

		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale

		let scaledSize = imageSize * minScale
		let newImageFrame = CGRect(origin: .zero, size: scaledSize)
		zoomedView.frame = newImageFrame

		centerImage()
	}

	private func centerImage() {
		let imageViewSize = zoomedView.frame.size
		let scrollViewSize = view.frame.size

		let paddings = (scrollViewSize - imageViewSize) / 2

		let horizPadding = max(paddings.width, 0)
		let vertPadding = max(paddings.height, 0)

		scrollView.contentInset = UIEdgeInsets(horizontal: horizPadding, vertical: vertPadding)
	}

	@objc private func doubleTappedImage(_ sender: UITapGestureRecognizer) {
		guard zoomOnDoubleTap else { return }
		if scrollView.zoomScale == scrollView.minimumZoomScale {
			let zoomRect = zoomRectangle(scale: scrollView.maximumZoomScale, center: sender.location(in: sender.view))
			scrollView.zoom(to: zoomRect, animated: true)
		} else {
			scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
		}
	}

	private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
		let zoomSize = zoomedView.frame.size / scale
		let zoomOrigin = center - (center * scrollView.zoomScale)

		return CGRect(origin: zoomOrigin, size: zoomSize)
	}

	public func reset() {
		updateViews()
	}
}


extension ZoomyViewController: UIScrollViewDelegate {
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		zoomedView
	}

	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		centerImage()
	}
}


