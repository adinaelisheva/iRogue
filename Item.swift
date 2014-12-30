//
//  Item.swift
//  iRogue
//
//  Created by Adina Rubinoff on 12/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import UIKit

//ADD ANY NEW ITEMS YOU MAKE TO THESE LISTS
//yes this is crude but deal with it
enum ItemTypes : UInt32 {
    case Food=0, Potion, Weapon, Scroll, Clothing, Ring, Amulet, Money, LAST, NONE
}

let itemsMap : [ItemTypes : [()->Item]] = [
    ItemTypes.Food : [{BreadRation()},{Apple()},{MeatRation()},{Pear()},{Choko()}],
    .Potion : [{PotInvisibility()},{PotPoison()},{PotLevitation()},{PotMutation()},{PotStrength()},{PotWisdom()},{PotMagic()}],
    .Weapon : [{Spear()},{Club()},{Sword()},{Mace()},{Pike()},{Machete()},{Trident()},{Katana()},{DeadFish()}],
    .Scroll : [{getDistRandomScroll()}],
    .Clothing : [{Shirt()}],
    .Ring : [{RingHunger()}],
    .Amulet : [{AmSpeed()}],
    .Money : [{Money()}]
]

func getPurelyRandomItem() -> Item{
    if let type = ItemTypes(rawValue:(arc4random_uniform(ItemTypes.LAST.rawValue))){
        if let list = itemsMap[type]{
            return list[Int(arc4random_uniform(UInt32(list.count)))]()
        }
        
    }
    return Money()
}

//this follows a better distribution. Will need to be edited if more item types are added
func getDistRandomItem() -> Item{
    let x = arc4random_uniform(100)
    var type : ItemTypes
    //custom distribution: 20% clothes, 20% weapon, 15% scroll, 15% potion, 15% food, 13% money, 1% ring, 1% amulet
    if x < 20 {
        type = .Clothing
    } else if x < 40 {
        type = .Weapon
    } else if x < 55 {
        type = .Scroll
    } else if x < 70 {
        type = .Potion
    } else if x < 85 {
        type = .Food
    } else if x < 98 {
        type = .Money
    } else if x < 99 {
        type = .Ring
    } else {
        type = .Amulet
    }
    if let list = itemsMap[type]{
        return list[Int(arc4random_uniform(UInt32(list.count)))]()
    }
    return Money()
}

func getDistRandomScroll() -> Scroll{
    let x = arc4random_uniform(100)
    if x < 100 {
        return ScrFear()
    }
    return ScrFear()

}

class Item : Entity {
    
    var autopickup = false
    
    var type = ItemTypes.NONE
    var useString = "Use"
    var adjective = "Generic"
    
    func useFn(ent : Entity) {
        if let mob = ent as? Mob{
            //this will have to be updated in the future with "put ons" etc
            Game.sharedInstance.Log("\(mob.name) \(useString.lowercaseString)s the \(name)")
        }
    }
    
    init(name: String?, description: String?, char: Character?, color: UIColor?,type:ItemTypes) {
        super.init(name:name,description:description,char:char,color:color)
        self.type = type
        interactable = "Pickup"
    }
    
    override func interact(mob: Mob) {
        //tell the mob to deal with picking me up
        mob.pickup(self)
        removeSelfFromLevel()
    }
    
    
    func removeSelfFromInventory(mob : Mob){
        if let arr = mob.inventory[type]?{
            if let i = getOwnIndex(arr)? {
               mob.inventory[type]!.removeAtIndex(i)
            }
        }
    }
    
    func replaceSelfInInventory(mob:Mob,newIt:Item?){
        if newIt == nil{
            return removeSelfFromInventory(mob)
        }
        //abort if you're not the same type
        if newIt!.type != type { return }
        
        if let arr = mob.inventory[type]?{
            if let i = getOwnIndex(arr)?{
                mob.inventory[type]![i] = newIt!
            }
        }
    }

}

//////
// super classes of items
//////

//consumables that affect HP
class Food : Item {
    
    var hpEffect : Int
    
    init(name:String,description:String,color:UIColor,hpEffect:Int){
        self.hpEffect = hpEffect
        //all food has char of '%'
        super.init(name:name,description:description,char:"%",color:color,type:.Food)
        useString = "Eat"
        autopickup = true
        adjective = "fresh"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob{
            mob.hp += hpEffect
            removeSelfFromInventory(mob)
            Game.sharedInstance.Log("\(mob.name) gains \(hpEffect) hp!")
        }
    }
}

//consumables that have various effects
class Potion : Item {
    init(description:String,color:UIColor){
        //all potions are just called 'potion' as a short name
        super.init(name:"potion",description:description,char:"!",color:color,type:.Weapon)
        useString = "Drink"
        autopickup = true
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob {
            removeSelfFromInventory(mob)
        }
    }
}

//equippables that affect attack ability
class Weapon : Item {
    
    var damageMod = 1
    
    init(name:String,description:String,color:UIColor){
        super.init(name:name,description:description,char:")",color:color,type:.Weapon)
        let x = arc4random_uniform(5)
        if x == 0{
            adjective = "wooden"
            self.color = UIColor.brownColor()
        } else if x == 1{
            adjective = "copper"
            self.color = UIColor(red: 0.85, green: 0.6, blue: 0.04, alpha: 1)
        } else if x == 2{
            adjective = "gold"
            self.color = UIColor.yellowColor()
        } else if x == 3{
            adjective = "steel"
        } else if x == 4{
            adjective = "stone"
        }
        useString = "Equip"
    }

    override func useFn(ent: Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob {
            replaceSelfInInventory(mob, newIt: mob.weapon)
            mob.weapon = self
        }
    }
}

//consumables that have various effects
class Scroll : Item {
    init(description:String){
        super.init(name:"scroll",description:description,char:"?",color:UIColor.whiteColor(),type:.Scroll)
        useString = "Read"
        autopickup = true
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob {
            removeSelfFromInventory(mob)
        }
    }
}

//equippables that affect AC, among other things
class Clothing : Item {
    
    var armorMod = 1
    
    init(name:String,description:String,color:UIColor){
        super.init(name:name,description:description,char:"[",color:color,type:.Clothing)
        useString="Equip"
    }
    override func useFn(ent: Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob {
            replaceSelfInInventory(mob, newIt: mob.clothing)
            mob.clothing = self
        }
    }
}

//equippables that have various effects
class Jewelry : Item {
    init(name:String,description:String,char:Character,color:UIColor,type:ItemTypes){
        super.init(name:name,description:description,char:char,color:color,type:type)
        useString = "Put on"
        autopickup = true
    }
    
    override func useFn(ent: Entity) {
        super.useFn(ent)
    }
}

class Ring : Jewelry {
    init(description:String,color:UIColor){
        super.init(name:"ring",description:description,char:"=",color:color,type:.Ring)
    }
    override func useFn(ent: Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob {
            replaceSelfInInventory(mob, newIt: mob.ring)
            mob.ring = self
        }
    }
}

class Amulet : Jewelry {
    init(description:String,color:UIColor){
        super.init(name:"amulet",description:description,char:"\"",color:color,type:.Amulet)
    }
    override func useFn(ent: Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob {
            replaceSelfInInventory(mob, newIt: mob.amulet)
            mob.amulet = self
        }
    }
}

//////
// more specific subclasses of items
//////

class Money : Item {
    var amt : Int
    init(){
        //more custom distributions
        let x = arc4random_uniform(100)
        if x < 50 {
            //small pile, 0-40
            amt = Int(arc4random_uniform(40))
        } else if x < 75 {
            //medium pile, 40-60
            amt = 40 + Int(arc4random_uniform(20))
        } else if x < 95 {
            //large pile, 60-80
            amt = 60 + Int(arc4random_uniform(20))
        } else {
            //giant pile! 80-100
            amt = 80 + Int(arc4random_uniform(20))
        }
        super.init(name:"money",description:"A pile of shiny gold coins!",char:"$",color:UIColor.yellowColor(),type:.Money)
        useString = "Deposit"
        autopickup = true
    }
    override func interact(mob: Mob) {
        removeSelfFromLevel()
        mob.gold += amt
        Game.sharedInstance.Log("\(mob.name) got \(amt) coins - total \(mob.gold)")
    }
}

class Apple : Food {
    init(){
        var colorS = "red"
        var color = UIColor.redColor()
        if(arc4random_uniform(2) == 0) { colorS = "green"; color = UIColor.greenColor() }
        super.init(name:"apple",description:"A crisp \(colorS) apple.",color:color,hpEffect:1)
    }
}
class MeatRation : Food {
    init(){
        super.init(name:"meat ration",description:"A ration of dried meat.",color:UIColor.brownColor(),hpEffect:5)
    }
}
class BreadRation : Food {
    init(){
        super.init(name:"bread ration",description:"A stale crust of bread.",color:UIColor(red: 0.85, green: 0.74, blue: 0.52, alpha: 1),hpEffect:4)
    }
}
class Pear : Food {
    init(){
        super.init(name:"pear",description:"A nice fresh pear.",color:UIColor.greenColor(),hpEffect:2)
    }
}
class Choko : Food {
    init(){
        super.init(name:"choko",description:"A mystery... fruit?",color:UIColor.yellowColor(),hpEffect:3)
    }
}
class Cake : Food {
    init(){
        var flavor = "chocolate"
        var color = UIColor.brownColor()
        let x = arc4random_uniform(3)
        if(x == 0) {
            flavor = "vanilla"
            color = UIColor.whiteColor()
        } else if (x==1){
            flavor = "strawberry"
            color = UIColor(red: 0.94, green: 0.65, blue: 0.84, alpha: 1)
        }
        
        super.init(name:"cake",description:"A moist piece of \(flavor) cake",color:color,hpEffect:4)
    }
}

class PotInvisibility : Potion {
    init(){
        //later color and desc should be generated randomly, but consistent per session
        super.init(description:"A frothy white potion",color:UIColor.whiteColor())
        adjective = "frothy white"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        Game.sharedInstance.Log("\(ent.name) becomes briefly invisible!\nIt was a potion of invisibility.")
        //TODO later: actually implement that; remembering potion names
    }
}

class PotPoison : Potion {
    init(){
        super.init(description:"A bubbly black potion",color:UIColor.grayColor())
        adjective = "bubbly black"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        if let mob = ent as? Mob {
            Game.sharedInstance.Log("Yuck! \(ent.name) feels sick.\nIt was a potion of poison.")
            mob.hp -= 5
        }
        
        //TODO: poisoned as a status with decreasing health over time
    }
}


class PotLevitation : Potion {
    init(){
        super.init(description:"A sparkly blue potion",color:UIColor.blueColor())
        adjective = "sparkly blue"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        Game.sharedInstance.Log("\(ent.name) floats gently off the ground.\nIt was a potion of levitation.")
        //TODO later: actually implement that
    }
}

class PotMutation : Potion {
    init(){
        super.init(description:"A cloudy gray potion",color:UIColor.grayColor())
        adjective = "cloudy gray"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        Game.sharedInstance.Log("\(ent.name) feels strong.\n\(ent.name)'s eyes grow cloudy.\n\(ent.name)'s back stretches.\nIt was a potion of mutation.")
        //TODO later: actually implement that
    }
}

class PotStrength : Potion {
    init(){
        super.init(description:"A murky black potion",color:UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
        adjective = "murky black"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        Game.sharedInstance.Log("\(ent.name) feels strong!\nIt was a potion of strength.")
        //TODO later: actually implement that
    }
    
}

class PotWisdom : Potion {
    init(){
        super.init(description:"A sparkly white potion",color:UIColor.whiteColor())
        adjective = "sparkly white"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        Game.sharedInstance.Log("\(ent.name) feels wise.\nIt was a potion of wisdom.")
        //TODO later: actually implement that
    }
    
}
class PotMagic : Potion {
    init(){
        super.init(description:"A cloudy green potion",color:UIColor.greenColor())
        adjective = "cloudy green"
    }
    
    override func useFn(ent : Entity) {
        super.useFn(ent)
        Game.sharedInstance.Log("Magic rushes through \(ent.name)'s veins.\nIt was a potion of magic.")
        //TODO later: actually implement that
    }
}


class Spear : Weapon {
    init(){
        //child resets description after init
        super.init(name:"spear",description:"",color:UIColor.grayColor())
        damageMod = 2
        description = "A pointy \(adjective) spear."
    }
}

class Club : Weapon {
    init(){
        super.init(name:"spear",description:"",color:UIColor.grayColor())
        damageMod = 1
        description = "A hefty \(adjective) club."
    }
}

class Sword : Weapon {
    init(){
        super.init(name:"spear",description:"",color:UIColor.grayColor())
        damageMod = 4
        description = "A sharp \(adjective) sword."
    }
}

class Mace : Weapon {
    init(){
        super.init(name:"spear",description:"",color:UIColor.grayColor())
        damageMod = 4
        description = "A sturdy \(adjective) mace."
    }
}

class Pike : Weapon {
    init(){
        super.init(name:"spear",description:"",color:UIColor.grayColor())
        damageMod = 2
        description = "A sharp \(adjective) pike."
    }
}

class Machete : Weapon {
    init(){
        super.init(name:"spear",description:"",color:UIColor.grayColor())
        damageMod = 2
        description = "A wicked \(adjective) machete."
    }
}

class Trident : Weapon {
    init(){
        super.init(name:"spear",description:"",color:UIColor.grayColor())
        damageMod = 3
        description = "A sharp \(adjective) trident."
    }
}

class Katana : Weapon{
    init(){
        super.init(name:"katana",description:"",color:UIColor.grayColor())
        damageMod = 5
        description = "A thin \(adjective) katana."
    }
}

class DeadFish : Weapon {
    init(){
        super.init(name:"dead fish",description:"A gross old fish? Really?",color:UIColor.blueColor())
        damageMod = 10
        adjective = "gross"
    }
}

class ScrFear : Scroll {
    init(){
        //again, should be random in the future
        super.init(description:"A scroll labeled YABSLBAI.")
        adjective = "YABSLBAI"
    }
    override func useFn(ent : Entity) {
        super.useFn(ent)
        Game.sharedInstance.Log("Adinex's face becomes a terrifying mask!")
        let mobs = Game.sharedInstance.level.things.filter { (thing) -> Bool in
            if thing === ent { return false }
            if !(thing is AIMob) { return false }
            if Math.distance(thing.coords,b:ent.coords) > 5 { return false }
            return true
        }
        for mob in mobs as [AIMob]{
            Game.sharedInstance.Log("\(mob.name) flees!")
            mob.state = .FleeTarget
        }
        
        //TODO later: remembering scroll names
    }
}

class Shirt : Clothing {
    init(){
        super.init(name:"shirt",description:"A plain cloth shirt.",color:UIColor.brownColor())
        adjective = "cloth"
    }
}

class RingHunger : Ring {
    init(){
        super.init(description:"A sparkly golden ring",color:UIColor.yellowColor())
        adjective = "sparkly golden"
    }
}

class AmSpeed : Amulet {
    init(){
        super.init(description:"A battered copper amulet",color:UIColor.brownColor())
        adjective = "battered copper"
    }
}














