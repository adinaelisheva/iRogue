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
    case Food=0, Potion, Weapon, Scroll, Clothing, Ring, Amulet, Money, LAST
}

let itemsMap : [ItemTypes : [()->Item]] = [
    ItemTypes.Food : [{Bread()}],
    .Potion : [{potInvisibility()}],
    .Weapon : [{Spear()}],
    .Scroll : [{scrFear()}],
    .Clothing : [{Shirt()}],
    .Ring : [{ringHunger()}],
    .Amulet : [{amSpeed()}],
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
    //custom distribution: 20% clothes, 20% weapon, 15% scroll, 15% potion, 15% food, 10% money, 3% ring, 2% amulet
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
    } else if x < 95 {
        type = .Money
    } else if x < 98 {
        type = .Ring
    } else {
        type = .Amulet
    }
    if let list = itemsMap[type]{
        return list[Int(arc4random_uniform(UInt32(list.count)))]()
    }
    return Money()
}

class Item : Entity {
    override init(name: String?, description: String?, char: Character?, color: UIColor?) {
        super.init(name:name,description:description,char:char,color:color)
        interactable = "Pickup"
    }
    
    override func interact(mob: Mob) {
        //tell the mob to deal with picking me up
        mob.pickup(self)
        removeSelfFromLevel()
    }
    func removeSelfFromLevel(){
        for i in 0..<Game.sharedInstance.level.things.count{
            if Game.sharedInstance.level.things[i] === self{
                Game.sharedInstance.level.things.removeAtIndex(i)
                remove()
                return
            }
        }
    }
}

//////
// super classes of items
//////

//consumables that affect HP
class Food : Item {
    init(name:String,description:String,color:UIColor){
        //all food has char of '%'
        super.init(name:name,description:description,char:"%",color:color)
    }
}

//consumables that have various effects
class Potion : Item {
    init(description:String,color:UIColor){
        //all potions are just called 'potion' as a short name
        super.init(name:"potion",description:description,char:"!",color:color)
    }
}

//equippables that affect attack ability
class Weapon : Item {
    init(name:String,description:String,color:UIColor){
        super.init(name:name,description:description,char:")",color:color)
    }
}

//consumables that have various effects
class Scroll : Item {
    init(description:String){
        super.init(name:"scroll",description:description,char:"?",color:UIColor.whiteColor())
    }
}

//equippables that affect AC, among other things
class Clothing : Item {
    init(name:String,description:String,color:UIColor){
        super.init(name:name,description:description,char:"[",color:color)
    }
}

//equippables that have various effects
class Jewelry : Item {
    init(name:String,description:String,char:Character,color:UIColor){
        super.init(name:name,description:description,char:char,color:color)
    }
}

class Ring : Jewelry {
    init(description:String,color:UIColor){
        super.init(name:"ring",description:description,char:"=",color:color)
    }
}

class Amulet : Jewelry {
    init(description:String,color:UIColor){
        super.init(name:"amulet",description:description,char:"\"",color:color)
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
        super.init(name:"money",description:"A pile of shiny gold coins!",char:"$",color:UIColor.yellowColor())
    }
    override func interact(mob: Mob) {
        removeSelfFromLevel()
        mob.gold += amt
        Game.sharedInstance.Log("\(mob.name) got \(amt) coins - total \(mob.gold)")
    }
}

class Bread : Food {
    init(){
        super.init(name:"bread",description:"A fresh loaf of bread.",color:UIColor.brownColor())
    }
}

class potInvisibility : Potion {
    init(){
        //later color and desc should be generated randomly, but consistent per session
        super.init(description:"A frothy white potion",color:UIColor.whiteColor())
    }
}

class Spear : Weapon {
    init(){
        super.init(name:"spear",description:"A pointy metal spear.",color:UIColor.grayColor())
    }
}

class scrFear : Scroll {
    init(){
        //again, should be random in the future
        super.init(description:"A scroll labeled YABSLBAI.")
    }
}

class Shirt : Clothing {
    init(){
        super.init(name:"shirt",description:"A plain cloth shirt.",color:UIColor.brownColor())
    }
}

class ringHunger : Ring {
    init(){
        super.init(description:"A sparkly golden ring",color:UIColor.yellowColor())
    }
}

class amSpeed : Amulet {
    init(){
        super.init(description:"A battered copper amulet",color:UIColor.brownColor())
    }
}














