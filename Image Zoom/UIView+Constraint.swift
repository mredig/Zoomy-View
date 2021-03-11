import UIKit

extension UIView {
	struct ConstraintEdgeToggle {
		let top: Bool
		let bottom: Bool
		let leading: Bool
		let trailing: Bool
	}

	@discardableResult func constrain(
		subview: UIView,
		inset: UIEdgeInsets = .zero,
		safeArea: ConstraintEdgeToggle = false,
		createConstraintsFor createConstraints: ConstraintEdgeToggle = true,
		activate: Bool = true) -> [NSLayoutConstraint] {

		var constraints: [NSLayoutConstraint] = []

		guard subview.isDescendant(of: self) else {
			print("Need to add subview: \(subview) to parent: \(self) first.")
			return constraints
		}

		defer {
			if activate {
				NSLayoutConstraint.activate(constraints)
			}
		}

		subview.translatesAutoresizingMaskIntoConstraints = false

		let topAnchor = safeArea.top ? self.safeAreaLayoutGuide.topAnchor : self.topAnchor
		let bottomAnchor = safeArea.bottom ? self.safeAreaLayoutGuide.bottomAnchor : self.bottomAnchor
		let leadingAnchor = safeArea.leading ? self.safeAreaLayoutGuide.leadingAnchor : self.leadingAnchor
		let trailingAnchor = safeArea.trailing ? self.safeAreaLayoutGuide.trailingAnchor : self.trailingAnchor

		if createConstraints.top { constraints.append(subview.topAnchor.constraint(equalTo: topAnchor, constant: inset.top)) }
		if createConstraints.leading { constraints.append(subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.leading)) }
		if createConstraints.bottom { constraints.append(bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: inset.bottom)) }
		if createConstraints.trailing { constraints.append(trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: inset.trailing)) }

		return constraints
	}
}

extension UIView.ConstraintEdgeToggle: ExpressibleByBooleanLiteral {
	init(uniform: Bool) {
		self.init(horizontal: uniform, vertical: uniform)
	}

	init(horizontal: Bool, vertical: Bool) {
		self.top = vertical
		self.bottom = vertical
		self.leading = horizontal
		self.trailing = horizontal
	}

	public init(booleanLiteral: Bool) {
		self.init(uniform: booleanLiteral)
	}
}

/// Add semantic support for modularity between right to left orientations
extension UIEdgeInsets: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {

	var leading: CGFloat {
		get { left }
		set { left = newValue }
	}

	var trailing: CGFloat {
		get { right }
		set { right = newValue }
	}

	init(uniform: CGFloat = 0) {
		self.init(top: uniform, left: uniform, bottom: uniform, right: uniform)
	}

	init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}

	init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
		self.init(top: top, left: leading, bottom: bottom, right: trailing)
	}

	public init(floatLiteral value: Double) {
		self.init(uniform: CGFloat(value))
	}

	public init(integerLiteral value: Int) {
		self.init(uniform: CGFloat(value))
	}
}
