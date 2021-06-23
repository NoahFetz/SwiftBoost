// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UIView {
    
    /**
     SparrowKit: Init `UIView` object with background color.
     
     - parameter backgroundColor: Color which using for background.
     */
    convenience init(backgroundColor color: UIColor) {
        self.init()
        backgroundColor = color
    }
    
    // MARK: - Helpers
    
    /**
     SparrowKit: Get controller, on which place current view.
     
     - warning:
     If view not added to any controller, return nil.
     */
    var viewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /**
     SparrowKit: Add many subviews as array.
     
     - parameter subviews: Array of `UIView` objects.
     */
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /**
     SparrowKit: Remove all subviews.
     */
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    /**
     SparrowKit: Take screenshoot of view as `UIImage`.
     */
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - Layout
    
    /**
     SparrowKit: Set specific width and after it fit view.
     
     - warning:
     Fit view can be return zero height. View shoud support it.
     */
    func setWidthAndFit(width: CGFloat) {
        frame.setWidth(width)
        sizeToFit()
    }
    
    /**
     SparrowKit: Set center X of current view to medium width of superview.
     
     - warning:
     If current view have not superview, center X is set to zero.
     */
    func setXCenter() {
        center.x = (superview?.frame.width ?? 0) / 2
    }
    
    /**
     SparrowKit: Set center Y of current view to medium height of superview.
     
     - warning:
     If current view have not superview, center Y is set to zero.
     */
    func setYCenter() {
        center.y = (superview?.frame.height ?? 0) / 2
    }
    
    /**
     SparrowKit: Set center of current view to center of superview.
     
     - warning:
     If current view have not superview, center is set to zero.
     */
    func setToCenter() {
        setXCenter()
        setYCenter()
    }
    
    // MARK: Readable Content Guide
    
    /**
     SparrowKit: Margins of readable frame.
     */
    var readableMargins: UIEdgeInsets {
        let layoutFrame = readableContentGuide.layoutFrame
        return UIEdgeInsets(
            top: layoutFrame.origin.y,
            left: layoutFrame.origin.x,
            bottom: frame.height - layoutFrame.height - layoutFrame.origin.y,
            right: frame.width - layoutFrame.width - layoutFrame.origin.x
        )
    }
    
    /**
     SparrowKit: Readable width of current view without horizontal readable margins.
     */
    var readableWidth: CGFloat {
        return readableContentGuide.layoutFrame.width
    }
    
    /**
     SparrowKit: Readable height of current view without vertical readable margins.
     */
    var readableHeight: CGFloat {
        return readableContentGuide.layoutFrame.height
    }
    
    /**
     SparrowKit: Readable frame of current view without vertical and horizontal readable margins.
     */
    var readableFrame: CGRect {
        let margins = readableMargins
        return CGRect.init(x: margins.left, y: margins.top, width: readableWidth, height: readableHeight)
    }
    
    // MARK: Layout Margins Guide
    
    /**
     SparrowKit: Width of current view without horizontal layout margins.
     */
    var layoutWidth: CGFloat {
        // ver 1
        // Depricated becouse sometimes return invalid size
        //return layoutMarginsGuide.layoutFrame.width
        
        // ver 2
        return frame.width - layoutMargins.left - layoutMargins.right
    }
    
    /**
     SparrowKit: Height of current view without vertical layout margins.
     */
    var layoutHeight: CGFloat {
        // ver 1
        // Depricated becouse sometimes return invalid size
        //return layoutMarginsGuide.layoutFrame.height
        
        // ver 2
        return frame.height - layoutMargins.top - layoutMargins.bottom
    }
    
    /**
     SparrowKit: Frame of current view without horizontal and vertical layout margins.
     */
    var layoutFrame: CGRect {
        return CGRect.init(x: layoutMargins.left, y: layoutMargins.top, width: layoutWidth, height: layoutHeight)
    }
    
    /**
     SparrowKit: Set view equal frame to superview frame via frames.
     
     - warning:
     If view not have superview, nothing happen.
     */
    func setEqualSuperviewBounds() {
        guard let superview = self.superview else { return }
        frame = superview.bounds
    }
    
    /**
     SparrowKit: Set view equal frame to superview frame via `autoresizingMask`.
     */
    func setEqualSuperviewBoundsWithAutoresizingMask() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /**
     SparrowKit: Set view equal frame to superview frame via Auto Layout.
     
     - warning:
     If view not have superview, constraints will not be added.
     */
    func setEqualSuperviewBoundsWithAutoLayout() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    /**
     SparrowKit: Set view equal frame to superview frame exlude margins via Auto Layout.
     
     - warning:
     If view not have superview, constraints will not be added.
     */
    func setEqualSuperviewMarginsWithAutoLayout() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor),
            leftAnchor.constraint(equalTo: superview.layoutMarginsGuide.leftAnchor),
            rightAnchor.constraint(equalTo: superview.layoutMarginsGuide.rightAnchor),
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Appearance
    
    /**
     SparrowKit: Wrapper for layer property `masksToBounds`.
     */
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    /**
     SparrowKit: Correct rounded corners by current frame.
     
     - important:
     Need call after changed frame. Better leave it in `layoutSubviews` method.
     
     - parameter corners: Case of `UIRectCorner`
     - parameter radius: Amount of radius.
     */
    func roundCorners(_ corners: UIRectCorner = .allCorners, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    /**
     SparrowKit: Rounded corners to maximum of corner radius.
     
     - important:
     Need call after changed frame. Better leave it in `layoutSubviews` method.
     */
    func roundCorners() {
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
    
    /**
     SparrowKit: Wrapper for layer property `borderColor`.
     */
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /**
     SparrowKit: Wrapper for layer property `borderWidth`.
     */
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /**
     SparrowKit: Add shadow.
     
     - parameter color: Color of shadow.
     - parameter radius: Blur radius of shadow.
     - parameter offset: Vertical and horizontal offset from center fro shadow.
     - parameter opacity: Alpha for shadow view.
     */
    func addShadow(ofColor color: UIColor, radius: CGFloat, offset: CGSize, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    /**
     SparrowKit: Add paralax. Depended by angle of device.
     Can be not work is user reduce motion on settins device.
     
     - parameter amount: Amount of paralax effect.
     */
    func addParalax(amount: CGFloat) {
        motionEffects.removeAll()
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }
    
    /**
     SparrowKit: Remove paralax.
     */
    func removeParalax() {
        motionEffects.removeAll()
    }
    
    // MARK: - Animations
    
    /**
     SparrowKit: Appear view with fade in animation.
     
     - parameter duration: Duration of animation.
     - parameter completion: Completion when animation ended.
     */
    func fadeIn(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /**
     SparrowKit: Hide view with fade out animation.
     
     - parameter duration: Duration of animation.
     - parameter completion: Completion when animation ended.
     */
    func fadeOut(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
#endif

