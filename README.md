# SWCombox
simple and clean combo box --  update to swift 4.0

## Install
```ruby
pod 'SWCombox', :git => 'https://github.com/sw0906/SWCombox.git'
```

## Sample Code
```swift
// Set up ComboBoxView
func setupComboBox() {
     let comboBox = SWComboxView()
     comboBox.bindData(comboxDelegate: self)
}
    
// SWComboxViewDelegate
extension ViewController : SWComboxViewDelegate {

    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        return ["good", "middle", "bad"]
    }


    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
    }

    func selectComboxAtIndex(index:Int, object: Any, combox withCombox: SWComboxView) { }

    func openCombox(isOpen: Bool, combox: SWComboxView) {}

    func configureComboxCell(combox: SWComboxView, cell: inout UITableViewCell) {}
}

```

## ComboBox Sample
![image](https://github.com/sw0906/SWCombox/blob/master/sample01.png) 
![image](https://github.com/sw0906/SWCombox/blob/master/sample02.png)
