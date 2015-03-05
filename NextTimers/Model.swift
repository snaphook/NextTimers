

import UIKit
import CoreData

@objc(Model)
class Model: NSManagedObject {
    
    @NSManaged var uid: String
    @NSManaged var name: String
    @NSManaged var reg_date: String
    @NSManaged var reg_length: String
    @NSManaged var push_notify: Bool
    @NSManaged var comment: String
    @NSManaged var start_date: String
    @NSManaged var start_url: String
    
}