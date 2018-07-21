import UIKit

@objc public protocol SWComboxViewDelegate {
    @objc optional func selectedAtIndex(index:Int, combox: SWComboxView)
    @objc optional func tapComboBox(isOpen: Bool, combox: SWComboxView)
    func swComboBox(combox: SWComboxView) -> SWComboBox
    func swComboBoxSelections(combox: SWComboxView) -> [Any]
}

struct SWComboxViewNibResourceType: NibResourceType {
    let bundle = Bundle(for: SWComboxView.self)
    let name = "SWComboxView"
}

open class SWComboxView: NibView, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var container: UIView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var button: UIButton!

    public var comboBox: SWComboBox!

    private var fullHeight: CGFloat = 0

    public weak var delegate: SWComboxViewDelegate!

    public var tableView:UITableView!

    public var list: [Any] {
        return delegate.swComboBoxSelections(combox: self)
    }

    public var defaultIndex = 0

    public var isOpen = false {
        didSet {
            self.fullHeight = isOpen ? self.tableView.height + self.frame.height : self.frame.height
        }
    }

    override open func commonInit() {
        let resourceType = SWComboxViewNibResourceType()
        _ = resourceType.firstView(owner: self)
        addSubviewToMaxmiumSize(view: container)

        self.isOpen = false
    }

    //MARK: action
    @IBAction func DidTapButton(_ sender: Any) {
        tapTheCombox()
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isOpen {
            if point.x <= frame.width && point.y <= fullHeight && point.y > frame.height {
                return self.tableView
            }
        }
        return super.hitTest(point, with: event)
    }
}

//MARK: bind

extension SWComboxView {

    open func bindData(comboxDelegate:SWComboxViewDelegate, seletedIndex: Int) {
        defaultIndex = seletedIndex
        delegate = comboxDelegate
        comboBox = delegate.swComboBox(combox: self)
        setupContentView()
    }

    func bindData(comboxDelegate:SWComboxViewDelegate) {
        bindData(comboxDelegate: comboxDelegate, seletedIndex: 0)
    }

}

extension SWComboxView {

    private func setupTable() {
        if tableView == nil
        {
            let rect = getTableOriginFrame()
            tableView = UITableView(frame: rect, style: UITableViewStyle.plain)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.delegate = self
            tableView.dataSource = self
            tableView.layer.borderWidth = 0.5;
            tableView.layer.borderColor = UIColor.lightGray.cgColor;
            self.addSubview(tableView)
        }
    }

    //MARK: table delegate/data source
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.size.height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table frame is \(self.tableView.frame)\n")
        print("table bounds is \(self.tableView.bounds)\n")
        print("self frame is \(frame) - bounds - \(bounds)")
        let cell = getCurrentCell(tableView: self.tableView, data: list[indexPath.row] as AnyObject)
        cell.addBottomLine(margin: 0, color: UIColor.lightGray)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaultIndex = indexPath.row
        dismissCombox()
    }

    //MARK: reload
    private func reloadData()
    {
        tableView.reloadData()
        
    }
    
    private func reloadViewWithIndex(_ index: Int)
    {
        defaultIndex = index
        let object: AnyObject = list[defaultIndex] as AnyObject
        self.setCurrentView(data: object)
    }
}

extension SWComboxView {

    public func getCurrentTitle() -> String {
        return comboBox?.title ?? ""
    }

    private func loadCurrentView(contentView:UIView, data: AnyObject) {
        contentView.addSubviewToMaxmiumSize(view: comboBox)
        comboBox.bind(data)
    }

    private func setCurrentView(data: AnyObject){
        comboBox.bind(data)
    }

    private func getCurrentCell(tableView: UITableView, data: AnyObject) -> UITableViewCell {
        let identifier = "comboBox"
        guard let comboBox = comboBox else { return UITableViewCell() }
        var cellFrame = comboBox.frame
        cellFrame.size.width = tableView.frame.size.width
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.frame = cellFrame
        let comboxC = delegate.swComboBox(combox: self)
        cell.contentView.addSubviewToMaxmiumSize(view: comboxC)
        comboxC.bind(data)
        return cell
    }

    private func setupContentView() {
        print("total count is \(list.count)")
        if defaultIndex < list.count
        {
            self.loadCurrentView(contentView: contentView, data: list[defaultIndex] as AnyObject)
        }
        else
        {
            self.loadCurrentView(contentView: contentView, data: list[0] as AnyObject)
        }
        self.addFrame()
    }

}

extension SWComboxView {
    
    //MARK: Tap Action
    private func tapTheCombox()
    {
        setupTable()

//        closeSelection()
        onAndOffSelection()

        self.delegate?.tapComboBox?(isOpen: !self.isOpen, combox: self)
    }

    
    //MARK: helper
    private func dismissCombox()
    {
        reloadViewWithIndex(defaultIndex)
        tapTheCombox()
        delegate?.selectedAtIndex?(index: defaultIndex, combox: self)
    }
    

    public func onAndOffSelection() {
        if self.isOpen {
            UIView.animate(withDuration: 0.3,
                           animations: { () -> Void in
                            var frame = self.tableView.frame
                            frame.size.height = 0
                            self.tableView.frame = frame
            },
                           completion: { finished in
                            self.tableView.removeFromSuperview()
                            self.isOpen = false
                            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)//CGAffineTransformRotate(self.arrow.transform,   CGFloat.pi)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                if self.list.count > 0
                {
                    self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: UITableViewScrollPosition.top, animated: true)
                }
                self.addSubview(self.tableView)
                self.bringSubview(toFront: self.tableView)
                self.tableView.frame = self.getTableFrame()
            }, completion: { finished in
                self.isOpen = true
                self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
        }
    }

}

extension SWComboxView {
    
    //table frame
    private func getTableOriginFrame() -> CGRect
    {
        let orginY = self.frame.size.height
        let orginX:CGFloat = 0
        let ori = CGRect(x:orginX, y:orginY, width:self.frame.size.width, height: 0)
        print("getTableOriginFrame - \(ori)")
        return ori
    }
    
    private func getTableFrame() -> CGRect
    {
        var frame  = tableView.frame
        let countNumber = self.list.count > 4 ? 4.5 : CGFloat(self.list.count)
        frame.size.height = self.contentView.frame.height * countNumber
        let fullHeight = UIScreen.main.bounds.size.height
        if frame.origin.y + frame.size.height > fullHeight {
            frame.size.height = fullHeight - frame.origin.y
        }
        print("getTableFrame - \(frame)")
        return frame
    }

}
