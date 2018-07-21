import UIKit

public protocol SWComboxViewDelegate: class {
    func selectComboxAtIndex(index:Int, object: Any, combox: SWComboxView)
    func openCombox(isOpen: Bool, combox: SWComboxView)
    func configureComboxCell(combox: SWComboxView, cell: inout UITableViewCell)

    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any]
}

struct SWComboxViewNibResourceType: NibResourceType {
    let bundle = Bundle(for: SWComboxView.self)
    let name = "SWComboxView"
}

open class SWComboxView: NibView {

    @IBOutlet var container: UIView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var button: UIButton!

    var comboBox: SWComboxSelectionView!

    public weak var delegate: SWComboxViewDelegate!
    public var tableView:UITableView!

    public var list: [Any] {
        return delegate.comboBoxSeletionItems(combox: self)
    }

    public var defaultIndex: Int = 0

    public var isOpen = false

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

    //MARK: Track table view touch event
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isOpen {
            // check if the point in table view
            let fullHeight = frame.height + tableView.height
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
        self.defaultIndex = seletedIndex
        delegate = comboxDelegate
        comboBox = delegate.comboxSeletionView(combox: self)
        setupContentView()
    }

    open func bindData(comboxDelegate:SWComboxViewDelegate) {
        bindData(comboxDelegate: comboxDelegate, seletedIndex: 0)
    }

}

extension SWComboxView: UITableViewDataSource, UITableViewDelegate {

    func setupTable() {
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
        let cell = getCurrentCell(tableView: self.tableView, data: list[indexPath.row] as AnyObject)
        cell.addBottomLine(margin: 0, color: UIColor.lightGray)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaultIndex = indexPath.row
        dismissCombox()
    }

    //MARK: reload
    func reloadData() {
        tableView.reloadData()

    }

    func reloadViewWithIndex(_ index: Int) {
        defaultIndex = index
        let object: AnyObject = list[defaultIndex] as AnyObject
        self.setCurrentView(data: object)
    }
}

extension SWComboxView {

    public func getCurrentTitle() -> String {
        return comboBox?.title ?? ""
    }

    func loadCurrentView(contentView:UIView, data: AnyObject) {
        contentView.addSubviewToMaxmiumSize(view: comboBox)
        comboBox.bind(data)
    }

    func setCurrentView(data: AnyObject){
        comboBox.bind(data)
    }

    func getCurrentCell(tableView: UITableView, data: AnyObject) -> UITableViewCell {
        let identifier = "comboBox"
        guard let comboBox = comboBox else { return UITableViewCell() }
        var cellFrame = comboBox.frame
        cellFrame.size.width = tableView.frame.size.width

        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.frame = cellFrame
        let comboxC = delegate.comboxSeletionView(combox: self)
        cell.contentView.addSubviewToMaxmiumSize(view: comboxC)
        comboxC.bind(data)
        delegate.configureComboxCell(combox: self, cell: &cell)
        return cell
    }

    func setupContentView() {
        if defaultIndex < list.count {
            self.loadCurrentView(contentView: contentView, data: list[defaultIndex] as AnyObject)
        } else {
            self.loadCurrentView(contentView: contentView, data: list[0] as AnyObject)
        }
        self.addFrame()
    }

}

extension SWComboxView {

    //MARK: Tap Action
    func tapTheCombox() {
        setupTable()
        onAndOffSelection()

        self.delegate.openCombox(isOpen: !self.isOpen, combox: self)
    }


    //MARK: helper
    func dismissCombox() {
        reloadViewWithIndex(defaultIndex)
        tapTheCombox()
        delegate.selectComboxAtIndex(index: defaultIndex, object: list[defaultIndex], combox: self)
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
    func getTableOriginFrame() -> CGRect {
        let orginY = self.frame.size.height
        let orginX:CGFloat = 0
        let ori = CGRect(x:orginX, y:orginY, width:self.frame.size.width, height: 0)
        return ori
    }

    func getTableFrame() -> CGRect {
        var frame  = tableView.frame
        let countNumber = self.list.count > 4 ? 4.5 : CGFloat(self.list.count)
        frame.size.height = self.contentView.frame.height * countNumber
        let fullHeight = UIScreen.main.bounds.size.height
        if frame.origin.y + frame.size.height > fullHeight {
            frame.size.height = fullHeight - frame.origin.y
        }
        return frame
    }

}

