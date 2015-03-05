//
//  testViewController.swift
//  NextTimers
//
//  Created by Jonas Dandanell on 2015-01-20.
//  Copyright (c) 2015 Dandanellfoto. All rights reserved.
//

import UIKit

class testViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,   UITableViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var autocompleteTableView: UITableView!
    
    // @IBOutlet weak var autocompleteTableView = UITableView(frame: CGRectMake(0,80,320,120), style: UITableViewStyle.Plain)
    
    var pastUrls = ["Men", "Women", "Cats", "Dogs", "Children"]
    var autocompleteUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        autocompleteTableView!.delegate = self
        autocompleteTableView!.dataSource = self
        autocompleteTableView!.scrollEnabled = true
        autocompleteTableView!.hidden = true
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool
    {
        println("banana")
        autocompleteTableView!.hidden = false
        var substring = (self.textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepCapacity: false)
        println(substring)
        
        for curString in pastUrls
        {
            println(curString)
            var myString: NSString! = curString as NSString
            var substringRange: NSRange! = myString.rangeOfString(substring)
            if (substringRange.location == 0)
            {
                autocompleteUrls.append(curString)
            }
        }
        
        autocompleteTableView!.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteUrls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier) as? UITableViewCell
        
        if let tempo1 = cell
        {
            let index = indexPath.row as Int
            cell?.textLabel?.text = autocompleteUrls[index]
        } else
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: autoCompleteRowIdentifier)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        textField.text = selectedCell.textLabel?.text
    }
}