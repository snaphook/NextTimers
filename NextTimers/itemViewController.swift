

import UIKit
import CoreData

class ItemViewController: UIViewController {
    
    @IBOutlet var textFieldUid: UITextField!
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldRegLength: UITextField!
    @IBOutlet var textViewComment: UITextView!
    @IBOutlet var switchPushNotify: UISwitch!
    
    var uid: String = ""
    var name: String = ""
    var reg_date: String = ""
    var reg_length: String = ""
    var push_notify: Bool = false
    var comment: String = ""
    
    var existingItem: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cancelButton : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelTapped:")
        var saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveTapped:")
        
        textViewComment.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        textViewComment.layer.borderWidth = 0.5
        textViewComment.layer.cornerRadius = 5
        textViewComment.clipsToBounds = true
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        if (existingItem != nil) {
            textFieldUid.text = uid
            textFieldName.text = name
            textFieldRegLength.text = reg_length
            textViewComment.text = comment
            if push_notify == true {
                switchPushNotify.setOn(true, animated: true)
            } else {
                switchPushNotify.setOn(false, animated: true)
            }
            
            textFieldName.enabled = false
            textFieldUid.enabled = false
            
            self.navigationItem.title = name as String
        } else {
            self.navigationItem.title = "Lägg till bevakning"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        // Reference to app delegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        // Reference moc
        let contxt = appDel.managedObjectContext!
        let ent = NSEntityDescription.entityForName("NextTimer", inManagedObjectContext: contxt)
        
        // let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateStr = dateFormatter.stringFromDate(NSDate())
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:ss"
        var timestamp = dateFormatter.stringFromDate(NSDate())
        
        if (existingItem != nil) {
            existingItem.setValue(textFieldUid.text as String, forKey: "uid")
            existingItem.setValue(textFieldName.text as String, forKey: "name")
            existingItem.setValue(textFieldRegLength.text as String, forKey: "reg_length")
            existingItem.setValue(textViewComment.text as String, forKey: "comment")
            existingItem.setValue(switchPushNotify.on, forKey: "push_notify")
        } else {
            var newNextTimer = Model(entity: ent!, insertIntoManagedObjectContext: contxt)
            
            // Map our properties
            newNextTimer.uid = textFieldUid.text
            newNextTimer.name = textFieldName.text
            newNextTimer.reg_length = textFieldRegLength.text
            newNextTimer.comment = textViewComment.text
            newNextTimer.reg_date = timestamp
            newNextTimer.push_notify = switchPushNotify.on
            newNextTimer.start_date = dateStr
            newNextTimer.start_url = "http://www.bt.se"
            
            // println(newNextTimer)
        }
        
        // Save context
        contxt.save(nil)
        
        // Navigate back to mainVC
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        
        // Navigate back to mainVC
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
