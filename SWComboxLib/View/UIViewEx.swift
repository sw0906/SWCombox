import UIKit

/// Represents a nib file on disk
public protocol NibResourceType {

    /// Bundle this nib is in or nil for main bundle
    var bundle: Bundle { get }

    /// Name of the nib file on disk
    var name: String { get }
}


public extension UINib {
    /**
     Returns a UINib object initialized to the nib file of the specified resource (R.nib.*).

     - parameter resource: The resource (R.nib.*) to load

     - returns: The initialized UINib object. An exception is thrown if there were errors during initialization or the nib file could not be located.
     */
    public convenience init(resource: NibResourceType) {
        self.init(nibName: resource.name, bundle: resource.bundle)
    }
}

extension NibResourceType {

    func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    /**
     Instantiate the nib to get the top-level objects from this nib

     - parameter ownerOrNil: The owner, if the owner parameter is nil, connections to File's Owner are not permitted.
     - parameter options: Options are identical to the options specified with -[NSBundle loadNibNamed:owner:options:]

     - returns: An array containing the top-level objects from the NIB
     */
    public func instantiate(withOwner ownerOrNil: Any?, options optionsOrNil: [AnyHashable : Any]? = [:]) -> [Any] {
        return UINib(resource: self).instantiate(withOwner: ownerOrNil, options: optionsOrNil)
    }
}


extension UIView {

    open func addSubviewToMaxmiumSize(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
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

    //MARK: add frame
    func addFrame() {
        layer.borderWidth = 1;
        self.layer.borderColor = UIColor.lightGray.cgColor
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

}
