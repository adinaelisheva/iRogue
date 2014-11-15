
import Foundation
import UIKit

class MainViewController: UIViewController {
    
    weak var gameVC: GameViewController!
    weak var game: Game!
    
    @IBOutlet weak var activityLog: UITextView!
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var magicButton: UIButton!
    @IBOutlet weak var religionButton: UIButton!
    @IBOutlet weak var miscButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var mpLabel: UILabel!
    
    func log(str:String) {
        //adding text to a non-selectable text field resets the font. THANKS COCOA
        activityLog.selectable = true
        activityLog.text = str
        activityLog.selectable = false
    }
    
    @IBAction func upClicked(sender: UIButton) {
        game.Log("@ \(gameVC.scene.charPos)")
        if gameVC.scene.charPos.y < gameVC.scene.gridSize.h-1 {
            gameVC.scene.charPos.y++
        }
    }
    @IBAction func rightClicked(sender: AnyObject) {
        game.Log("@ \(gameVC.scene.charPos)")
        if gameVC.scene.charPos.x < gameVC.scene.gridSize.w-1 {
            gameVC.scene.charPos.x++
        }
    }
    @IBAction func downClicked(sender: AnyObject) {
        game.Log("@ \(gameVC.scene.charPos)")
        if gameVC.scene.charPos.y > 0 {
            gameVC.scene.charPos.y--
        }
    }
    @IBAction func leftClicked(sender: AnyObject) {
        game.Log("@ \(gameVC.scene.charPos)")
        if gameVC.scene.charPos.x > 0 {
            gameVC.scene.charPos.x--
        }
    }
    
    @IBAction func itemsClicked(sender: AnyObject) {
    }
    @IBAction func magicClicked(sender: AnyObject) {
    }
    @IBAction func religionClicked(sender: AnyObject) {
    }
    @IBAction func miscClicked(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        var name = segue.identifier
        if name == "gameview" {
            gameVC = segue.destinationViewController as GameViewController;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ad = UIApplication.sharedApplication().delegate as? AppDelegate {
            
            // Hold onto this locally.
            game = ad.game
            
            // Set up the logging system
            game.logCallback = log
            game.Log(activityLog.text)
            
            
        } else {
            NSLog("Why no appdelegate?")
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}