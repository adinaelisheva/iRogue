
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
    
    
    @IBAction func upClicked(sender: UIButton) {
        
        takeTurnWithAction(Action(direction: Direction.UP))
        
        clickArrowButton(sender)
    }

    @IBAction func rightClicked(sender: UIButton) {
        
        takeTurnWithAction(Action(direction: Direction.RIGHT))
        
        clickArrowButton(sender)
    }
    @IBAction func downClicked(sender: UIButton) {

        takeTurnWithAction(Action(direction: Direction.DOWN))
        
        clickArrowButton(sender)
    }
    @IBAction func leftClicked(sender: UIButton) {
        
        takeTurnWithAction(Action(direction: Direction.LEFT))
        
        clickArrowButton(sender)
    }
    
    
    @IBAction func itemsClicked(sender: AnyObject) {
    }
    @IBAction func magicClicked(sender: AnyObject) {
    }
    @IBAction func religionClicked(sender: AnyObject) {
    }
    @IBAction func miscClicked(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ad = UIApplication.sharedApplication().delegate as? AppDelegate {
            
            // Hold onto this locally.
            game = ad.game
            
            // Set up the logging system
            game.logCallback = log
            game.Log(activityLog.text)
            
            
            nameLabel.text = game.playerMob.name
            xpLabel.text = String(game.xp)
            
            game.playerMob.skScene = gameVC.scene.addEntity(game.playerMob)
            game.aiMob.skScene = gameVC.scene.addEntity(game.aiMob)
            
            
        } else {
            NSLog("Why no appdelegate?")
        }
        
    }
    
    func takeTurnWithAction(action : Action) {
        
        game.takeTurnWithAction(action)
        
        game.playerMob.skScene?.position = getCellPosFromCoords(game.playerMob.coords)
        game.aiMob.skScene?.position = getCellPosFromCoords(game.aiMob.coords)
        
        
    }
    
    func getCellPosFromCoords(coords : (x:Int,y:Int)) -> CGPoint {
        let cs = gameVC.scene.cellSize
        var x = (coords.x*cs.w) + (cs.w/2)
        var y = (coords.y*cs.h) + (cs.h/2)
        return CGPoint(x:x,y:y)
    }
    
    
    
    
    func clickArrowButton(button: UIButton){
        UIView.animateWithDuration(0.1,
            animations: {
                button.alpha = 0.2
        })
        UIView.animateWithDuration(0.1,
            animations: {
                button.alpha = 0.1
        })
    }
    
    func log(str:String) {
        //adding text to a non-selectable text field resets the font. THANKS COCOA
        activityLog.selectable = true
        activityLog.text = str
        activityLog.selectable = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        var name = segue.identifier
        if name == "gameview" {
            gameVC = segue.destinationViewController as GameViewController;
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