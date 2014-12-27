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

class Item : Entity {
    
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
    init(){
        super.init(name:"money",description:"A pile of shiny gold coins!",char:"$",color:UIColor.yellowColor())
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














