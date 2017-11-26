//
//  OptionsViewController.swift
//  DevrantAvatar
//
//  Created by Noah Peeters on 10/29/17.
//  Copyright © 2017 Noah Peeters. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var properties: [AvatarProperty] = AvatarPropertyType.allTypes.map({ $0.withRandomValue() })
    
    let nameColumn = NSUserInterfaceItemIdentifier("name")
    let valueColumn = NSUserInterfaceItemIdentifier("value")
    let stepperColumn = NSUserInterfaceItemIdentifier("stepper")
    
    override func viewDidLoad() {
        startAvatarLoading()

        print(AvatarPropertyType.allTypes.reduce(1, {$0 * $1.optionsCount}))
    }
    
    func startAvatarLoading() {
        AvatarLoader.default.loadAvatar(Avatar(properties))
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        switch tableColumn?.identifier {
        case valueColumn?:
            guard let displayNames = properties[row].type.valueDisplayNames else {
                return nil
            }
            let cell = NSPopUpButtonCell()
            cell.addItems(withTitles: displayNames.reversed())
            return cell
        case stepperColumn?:
            let stepperCell = NSStepperCell()
            stepperCell.minValue = Double(properties[row].type.minValue)
            stepperCell.maxValue = Double(properties[row].type.maxValue)
            stepperCell.valueWraps = false
            return stepperCell
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let property = properties[row]
        
        switch tableColumn?.identifier {
        case nameColumn?:
            return property.type.displayName
        case valueColumn?:
            return property.type.valueDisplayNames == nil ? property.value : property.type.maxValue - property.value
        case stepperColumn?:
            return property.value
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        switch tableColumn?.identifier {
        case valueColumn?:
            let value: Int
            
            if let doubleObject = object as? Double {
                value = properties[row].type.maxValue - round(doubleObject)
            } else if let stringObject = object as? String, let doubleObject = Double(stringObject) {
                value = round(doubleObject)
            } else {
                return
            }
        
            properties[row].value = value
            startAvatarLoading()
        case stepperColumn?:
            let value = Int(round(object as! Double))
            properties[row].value = value
            startAvatarLoading()
            tableView.reloadData(
                forRowIndexes: IndexSet(integer: row),
                columnIndexes: IndexSet(integer: tableView.column(withIdentifier: valueColumn))
            )
        default:
            return
        }
    }
    
    func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        return false
    }
}


func round(_ double: Double) -> Int {
    return Int(round(double))
}
