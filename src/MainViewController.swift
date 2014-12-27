
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
        
        var dir: Direction;
        switch(sender){
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
                dir = Direction.NONE
        }
        
        takeTurnWithAction(Action(direction: dir))
        
        clickArrowButton(sender)
    }
    
    @IBAction func itemsClicked(sender: AnyObject) {
    }
    @IBAction func magicClicked(sender: AnyObject) {
    }
    @IBAction func religionClicked(sender: AnyObject) {
    }
    @IBAction func interactClicked(sender: AnyObject) {

        if interactables.count == 1 {
            interactables.first!.interact()
        } else if interactables.count > 1 {
            // TODO: Display a menu to interact with multiple things
            game.Log("Menu not implemented yet")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        game = Game(scene: gameVC.scene)
        
        updateInteractMenu()

        // Set up the logging system
        game.logCallback = log
        game.Log(activityLog.text)
        
        nameLabel.text = game.playerMob.name
        xpLabel.text = "XP:\(game.xp)"
        lvlLabel.text = "LVL:\(game.xpLevel)"
        
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
        gameVC.scene.camera.position = CGPoint(
            x: -offset.w + half.w  - GameScene.cellSize.w/2,
            y: -offset.h + half.h  - GameScene.cellSize.h/2)
        
    }
    
    func updateInteractMenu() {
     
        interactables = []
        
        let coord = game.playerMob.coords
        let tile = game.level.getTileAt(coord)
        
        
        if tile?.interactable != nil {
            interactables.append(tile!)
        }
        
        for ent in game.level.things.filter({ $0.interactable != nil && $0.coords.x == coord.x && $0.coords.y == coord.y }) {
            interactables.append(ent)
        }
        
        
        if (interactables.count == 0) {
            interactButton.enabled = false
        } else if (interactables.count == 1) {
            interactButton.enabled = true
            interactButton.setTitle(interactables[0].interactable!, forState: .Normal)
        } else {
            interactButton.enabled = true
            interactButton.setTitle("x\(interactables.count)", forState: .Normal)
        }
        
    }
    
    func takeTurnWithAction(action : Action) {
        
        game.takeTurnWithAction(action)
        
        updateInteractMenu()
        centerThePlayer()
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