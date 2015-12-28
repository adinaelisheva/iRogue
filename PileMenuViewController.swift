
import UIKit

class PileMenuViewController : UITableViewController {
    
    let cellIdentifier = "PileCell"
    
    var mvc : MainViewController?
    var items : [Entity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // UITableViewDataSource methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The plus one is for the "Nevermind"
        return (items?.count ?? 0) + 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items in pile"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)!
        if (indexPath.row < self.items!.count) {
            // Display information about the item
            let item = items![indexPath.row]
            cell.textLabel?.text = item.interactable! + " " + item.name
            cell.detailTextLabel?.text = item.description
        } else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = "Nevermind."
        }
        
        return cell
    }
    
    // UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.dismissViewControllerAnimated(true, completion: {
            if (indexPath.row < self.items!.count) {
                // If we selected an item, and not nevermind, take a turn doing that thing
                let item = self.items![indexPath.row]
                Game.sharedInstance.takeTurnWithAction(InteractAction(interactWith: item))
            }
        })
    }
}