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
     comboBox.dataSource = self
     comboBox.delegate = self
     comboBox.showMaxCount = 4
     comboBox.defaultSelectedIndex = 1 //start from 0
}

// SWComboxViewDataSourcce
//extension ViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        return ["good", "middle", "bad"]
    }


    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {}
}
    
// SWComboxViewDelegate
extension ViewController : SWComboxViewDelegate {
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {}

    func comboxOpened(isOpen: Bool, combox: SWComboxView) {}
}

```

## ComboBox Sample
![image](https://github.com/sw0906/SWCombox/blob/master/sample01.png) 
![image](https://github.com/sw0906/SWCombox/blob/master/sample02.png)
