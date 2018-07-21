# SWCombox
simple and clean combo box --  update to swift 4.0

## Sample Code
```swift
// Set up ComboBoxView
func setupComboBox() {
     let comboBox = SWComboxView()
     comboBox.bindData(comboxDelegate: self)
}
    
// SWComboxViewDelegate
extension ViewController : SWComboxViewDelegate {

    func swComboBoxSelections(combox: SWComboxView) -> [Any] {
        return ["good", "middle", "bad"]
    }


    func swComboBox(combox: SWComboxView) -> SWComboBox {
        return SWComboxTextSelection()
    }

    func selectedAtIndex(index:Int, object: Any, combox withCombox: SWComboxView) { }

    func tapComboBox(isOpen: Bool, combox: SWComboxView) {}

    func configureComboBoxCell(combox: SWComboxView, cell: inout UITableViewCell) {}
}

```

## ComboBox Sample
![image](https://github.com/sw0906/SWCombox/blob/master/sample01.png) 
![image](https://github.com/sw0906/SWCombox/blob/master/sample02.png)
