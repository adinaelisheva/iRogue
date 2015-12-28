
import Foundation
import UIKit

class MainViewController: UIViewController {
    
    weak var gameVC: GameViewController!
    weak var game: Game!

    // Items we're standing on that we can interact with
    var interactables = [Entity]()
    
    @IBOutlet weak var activityLog: UITextView!
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var nwButton: UIButton!
    @IBOutlet weak var neButton: UIButton!
    @IBOutlet weak var swButton: UIButton!
    @IBOutlet weak var seButton: UIButton!
    
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var magicButton: UIButton!
    @IBOutlet weak var religionButton: UIButton!
    @IBOutlet weak var interactButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lvlLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var mpLabel: UILabel!
    
    
    @IBAction func dirClicked(sender: UIButton) {
        
        var dir: Direction
        
        switch(sender)  {
            case upButton:
                dir = Direction.NORTH
            case downButton:
                dir = Direction.SOUTH
            case leftButton:
                dir = Direction.WEST
            case rightButton:
                dir = Direction.EAST
            case seButton:
                dir = Direction.SE
            case swButton:
                dir = Direction.SW
            case neButton:
                dir = Direction.NE
            case nwButton:
                dir = Direction.NW
            default:
                return
        }
        
        game.takeTurnWithAction(MoveAction(direction: dir))
        
        clickArrowButton(sender)
    }
    
    @IBAction func itemsClicked(sender: AnyObject) {
        let VC = self.storyboard?.instantiateViewControllerWithIdentifier("ItemsView") as! ItemViewController
        var items : [Item] = []
        for arr in game.playerMob.inventory.values {
            items += arr
        }
        VC.items = items
        self.presentViewController(VC, animated: true, completion: nil)
    }
    @IBAction func magicClicked(sender: AnyObject) {
    }
    @IBAction func religionClicked(sender: AnyObject) {
    }
    @IBAction func interactClicked(sender: AnyObject) {

        // If only one item is on our cell, do its action
        if interactables.count == 1 {
            game.takeTurnWithAction(InteractAction(interactWith: interactables.first!))
        } else if interactables.count > 1 {
            // Display the item pile UI for multiple items
            self.performSegueWithIdentifier("PileMenu", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        game = Game(scene: gameVC.scene)
        
        game.UICallback = updateUI
        
        game.logCallback = updateLabels
        game.Log(activityLog.text)
        
        nameLabel.text = game.playerMob.name
        xpLabel.text = "XP:\(game.xp)"
        lvlLabel.text = "LVL:\(game.xpLevel)"
        hpLabel.text = "HP:\(game.playerMob.hp)"
        
        updateInteractMenu()
    }
    
    override func viewDidLayoutSubviews() {
        // Our size is finalized. Do anything that depends on the size of the screen.

        centerThePlayer()
    }
    
    func centerThePlayer() {
        
        // Get the center point of the screen, in pixels
        let half : (w:Int, h:Int) = (Int(gameVC.view.frame.width / 2), Int(gameVC.view.frame.height / 2))
        
        // Get the player's offset into the world, in pixels
        let offset : (w:Int, h:Int) = (
            w: game.playerMob.coords.x * GameScene.cellSize.w,
            h: game.playerMob.coords.y * GameScene.cellSize.h)
        
        // Move the root object (camera) to put the player in the center.
        gameVC.scene.cameraNode.position = CGPoint(
            x: -offset.w + half.w  - GameScene.cellSize.w/2,
            y: -offset.h + half.h  - GameScene.cellSize.h/2)
        
    }
    
    func updateInteractMenu() {
     
        let lasttime = interactables
        
        interactables = []
        
        let coord = game.playerMob.coords
        let tile = game.level.getTileAt(coord)
        
        // Can we do something with the tile? Put it first in the list.
        if tile?.interactable != nil {
            interactables.append(tile!)
        }
        
        // Now put all remaining items/mobs/etc on the list.
        for ent in game.level.things.filter({ $0.interactable != nil && $0.coords.x == coord.x && $0.coords.y == coord.y }) {
            interactables.append(ent)
        }
        var numItems = interactables.count
        
        if (numItems > 0) {
            
            // Are we seeing a different set of items?
            // if they have different numbers of items, they're different
            var different = numItems != lasttime.count
            // Same items? See if each one is identical.
            if !different {
                for idx in 0..<numItems {
                    if interactables[idx] !== lasttime[idx] { different = true }
                }
            }
            
            if different {
                // Print info about the pile if it is not what we saw last time.
                //also, autopickup anything we should autopickup
                var infotext = "Here is: "
                for (i,item) in interactables.enumerate() {
                    //try to auto-pick-it-up
                    let it = item as? Item
                    if it?.autopickup ?? false{
                        it!.interact(game.playerMob)
                        numItems--
                    } else {
                        //if we didn't pick it up, add it to the list
                        infotext += item.name
                        if i < numItems - 1 {
                            infotext += ", "
                        }
                    }
                }
                //only print this if you haven't auto-picked-up everything
                if numItems > 0 {
                    game.Log(infotext)
                }
            }
            
            // Depending on how many there are, set up the button.
            if (numItems == 1) {
                interactButton.enabled = true
                interactButton.setTitle(interactables[0].interactable!, forState: .Normal)
            } else if (numItems > 0) {
                interactButton.enabled = true
                interactButton.setTitle("x\(numItems)", forState: .Normal)
            }
        } else {
            interactButton.enabled = false
        }
    }
    
    func updateUI() {
        updateInteractMenu()
        centerThePlayer()
        updateLabels()
    }

    func updateLabels(){
        hpLabel.text = "HP:\(game.playerMob.hp)"
        xpLabel.text = "XP:\(game.xp)"
        
        log(game.logString)
    }
    
    func clickArrowButton(button: UIButton){

        // fancy way to animate the button fading in and out
        // basically what you need to know is:
        // duration of total in-and-out is 0.1s, so 0.05s each
        // alpha fades to 0.2 and back to 0.1
        // .AllowUserInteraction allows the button to be clicked while animating
        // 'success in' turns the completion block into a boolean function, which it expects

        UIView.animateWithDuration(0.05,
            delay: 0.0,
            options: .AllowUserInteraction,
            animations: {
                button.alpha = 0.2
            }, completion: { success in UIView.animateWithDuration(0.05,
                delay: 0.0,
                options: .AllowUserInteraction,
                animations: {
                    button.alpha = 0.1
                },
                completion: nil
            ); return })
    }
    
    func log(str:NSAttributedString) {
        //adding text to a non-selectable text field resets the font. THANKS COCOA
        activityLog.selectable = true
        activityLog.attributedText = str
        activityLog.selectable = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        let name = segue.identifier
        if name == "gameview" {
            // We are embedding the game VC; set up references.
            gameVC = segue.destinationViewController as! GameViewController;
        } else if name == "PileMenu" {
            // We're popping up the pile menu; set up its references.
            let menu = segue.destinationViewController as! PileMenuViewController
            menu.items = interactables
            menu.mvc = self
        }
    }
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
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