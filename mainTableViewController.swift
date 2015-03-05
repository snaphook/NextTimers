

import UIKit
import CoreData
import MessageUI.MFMessageComposeViewController

class mainTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    var arrayNextTimers: Array<AnyObject> = []
    var alertAction: String? = ""
    
    @IBOutlet var filterList: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showNextTimer:", name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAMessage:", name: "actionTwoPressed", object: nil)
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func showNextTimer(notification: NSNotification) {
        // println("showNextTimer")

    }
    
    func showAMessage(notification: NSNotification) {
        // println("showAMessage")
        
        var message: UIAlertController = UIAlertController(title: "Följande häst startar idag", message: "Harry Haythrow, Solvalla lopp 6", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(message, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "NextTimer")
        
        arrayNextTimers = contxt.executeFetchRequest(freq, error: nil)!
        
        self.navigationItem.title = "Alla bevakningar"
        filterList.title = "Idag"
        filterList.action = "filterListOnToday"
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "update" {
            var selectedItem: NSManagedObject = arrayNextTimers[self.tableView.indexPathForSelectedRow()!.row] as NSManagedObject
            
            let IVC: ItemViewController = segue.destinationViewController as ItemViewController
            
            IVC.uid = selectedItem.valueForKeyPath("uid") as String
            IVC.name = selectedItem.valueForKeyPath("name") as String
            IVC.reg_length = selectedItem.valueForKeyPath("reg_length") as String
            IVC.comment = selectedItem.valueForKeyPath("comment") as String
            IVC.push_notify = selectedItem.valueForKeyPath("push_notify") as Bool
            IVC.existingItem = selectedItem
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return arrayNextTimers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID: String = "Cell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        
        var data: NSManagedObject = arrayNextTimers[indexPath.row] as NSManagedObject
    
        cell.textLabel?.text = data.valueForKeyPath("name") as? String
        
        var uid = data.valueForKeyPath("uid") as String
        var reg_length = data.valueForKeyPath("reg_length") as String
        var reg_date = data.valueForKeyPath("reg_date") as String
        
        var start_date = data.valueForKeyPath("start_date") as String
        
        if start_date != "" {
            cell.detailTextLabel?.text = "Skapad: \(reg_date)    Startar: \(start_date)"
        } else {
            cell.detailTextLabel?.text = "Skapad: \(reg_date)"
        }
        
        
        return cell
        
    }
    
    func refresh(sender:AnyObject)
    {
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.alertBody = "Harry Haythrow startar idag"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "FIRST_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt = appDel.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let tv = self.tableView {
                contxt.deleteObject(arrayNextTimers[indexPath.row] as NSManagedObject)
                arrayNextTimers.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
            var error: NSError? = nil
            if !contxt.save(&error) {
                abort()
            }
            
        }
    }
    
    // prepend this function with @IBAction if you want to call it from a Storyboard.
    @IBAction func launchMessageComposeViewController() {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.recipients = ["1111111111", "2222222222"]
            messageVC.body = "hello phone"
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        else {
            println("User hasn't setup Messages.app")
        }
    }
    
    @IBAction func filterListOnAll() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "NextTimer")
        
        arrayNextTimers = contxt.executeFetchRequest(freq, error: nil)!
        filterList.title = "Idag"
        filterList.action = "filterListOnToday"
        
        self.navigationItem.title = "Alla bevakningar"
        
        tableView.reloadData()
    }
    
    @IBAction func filterListOnToday() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "NextTimer")
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateStr = dateFormatter.stringFromDate(NSDate())
        
        let predicate = NSPredicate(format: "start_date == %@", dateStr)
        freq.predicate = predicate
    
        arrayNextTimers = contxt.executeFetchRequest(freq, error: nil)!
        filterList.title = "Alla"
        filterList.action = "filterListOnAll"
        
        self.navigationItem.title = "Dagens bevakningar"
        
        tableView.reloadData()
    }
    
    // this function will be called after the user presses the cancel button or sends the text
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
