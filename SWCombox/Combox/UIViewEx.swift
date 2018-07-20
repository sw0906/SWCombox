import UIKit

extension UIView {
    static func loadInstanceFromNib<T:UIView>() -> T? {
        var className = T.description()
        className = split(className)
        {
            $0 == "."
            }[1]
        let nib = UINib(nibName: className, bundle: nil)
        let topLevelObjects = nib.instantiate(withOwner:self, options: nil)
        
        return topLevelObjects.filter {
            $0 is T
            }.first as? T
    }
    
    static func loadInstanceFromNibNamed<T:UIView>(nibNamed: String) -> T? {
        let nib = UINib(nibName: nibNamed, bundle: nil)
        let topLevelObjects = nib.instantiate(withOwner:self, options: nil)
        
        return topLevelObjects.filter {
            $0 is T
            }.first as? T
    }
    
    //to containner
    static func loadInstanceFromNibNamedToContainner<T:UIView>(nibNamed: String, container: UIView)
        -> T? {
            let instance: T? = self.loadInstanceFromNibNamed(nibNamed: nibNamed)
            container.addSubview(instance!)
            instance?.frame = container.bounds
            return instance
    }
    
    static func loadInstanceFromNibNamedToContainner<T:UIView>(_ container: UIView)
        -> T? {
            let instance: T? = self.loadInstanceFromNib()
            let frame = container.bounds
            instance?.frame = frame
            container.addSubview(instance!)
            return instance
    }
    
    static func loadInstanceFromNibNamedToSrollContainner<T:UIView>(scrollView: UIScrollView)
        -> T? {
            let instance: T? = self.loadInstanceFromNib()
            scrollView.addSubview(instance!)
            let width = scrollView.bounds.width
            var frame = instance!.frame
            let ratio = CGFloat(frame.width) / CGFloat(frame.height)
//            var screenWidth = UIScreen.mainScreen.bounds.size.width
            frame.size = CGSize(width: width, height: width / ratio)//CGSizeMake(width, width / ratio)
            instance!.frame = frame
            instance!.setNeedsUpdateConstraints()
            instance!.setNeedsLayout()
            instance!.layoutIfNeeded()
            instance!.updateConstraintsIfNeeded()
            scrollView.contentSize = frame.size;
            return instance
    }
    
    func reloadViewSizeWithContainer(container: UIView) {
        self.bounds = container.bounds
        self.frame = container.frame
    }
    
    
    var x: CGFloat {
        get {
            return self.center.x
        }
        
        set(x) {
            var frame = self.frame
            frame.origin.x = x
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get {
            return self.center.y
        }
        
        set(y) {
            var frame = self.frame
            frame.origin.y = y
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(width) {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(height) {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    class func rasterizeView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage!
    }
    
    func isSubviewOf(view: UIView) -> Bool {
        for v in view.subviews {
            if v === self {
                return true
            }
        }
        return false
    }
    
    class func animateWithDuration(duration: TimeInterval, options: UIViewAnimationOptions, animations: () -> ()) {
        self.animateWithDuration(duration: duration, options: options, animations: animations)
    }
    
    class func roundView(view: UIView, onCorner rectCorner: UIRectCorner, radius: CGFloat) {
        let size = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
    func hideWithAnimation(hide: Bool) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            [unowned self] in
            if hide {
                self.alpha = 0
                self.isHidden = false
                self.alpha = 1
            } else {
                self.alpha = 0
            }
            }) {
                complete in
                if !hide {
                    self.isHidden = true
                }
        }
    }
    
    
    
    //MARK: add frame
    func addFrame() {
        layer.borderWidth = 1;
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    //MARK: add bottom Line
    func addBottomLine(color: UIColor) {
        var frameLine = frame
        frameLine.size.height = 0.5
        frameLine.origin.y = frame.size.height - 0.5
        frameLine.origin.x = 12
        frameLine.size.width -= 24
        let line = UIView(frame: frameLine)
        line.backgroundColor = color
        addSubview(line)
        bringSubview(toFront: line)
    }
    
    
    func addBottomLine(margin: CGFloat, color: UIColor) {
        var frameLine = frame
        frameLine.size.height = 0.5
        frameLine.origin.y = frame.size.height - 0.5
        frameLine.origin.x = margin
        frameLine.size.width -= margin * 2
        let line = UIView(frame: frameLine)
        line.backgroundColor = color
        addSubview(line)
    }
    
    func addBottomLine(marginLeft: CGFloat, marginRight: CGFloat, marginBottom: CGFloat, color: UIColor) {
        var frameLine = frame
        frameLine.size.height = 0.5
        frameLine.origin.y = frame.size.height - 0.5 - marginBottom
        frameLine.origin.x = marginLeft
        frameLine.size.width -= (marginLeft + marginRight)
        let line = UIView(frame: frameLine)
        line.backgroundColor = color
        addSubview(line)
    }
    
}
