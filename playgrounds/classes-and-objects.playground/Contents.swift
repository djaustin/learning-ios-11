//: Playground - noun: a place where people can play

import UIKit

class Enemy{
    var isAlive = true
    var attackPower = 9
    
    func kill(){
        isAlive = false
    }
    
    func isStrong() -> Bool {
        return attackPower > 10
    }
}
var a = 2

var ghost = Enemy()

ghost.attackPower
ghost.attackPower = 20
ghost.attackPower

ghost.isAlive
ghost.kill()
ghost.isAlive

ghost.isStrong()
