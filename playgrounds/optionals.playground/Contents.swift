//: Playground - noun: a place where people can play

import UIKit

var number: Int?
print(number)

let userInputString = "three"
let userInputInteger = Int(userInputString)

// Only executes if userInputInteger has a value / is not nil
// If we force unwrap an optional, our app will crash if the value is nil. This is much safer
if let num = userInputInteger {
    print(num * 7)
} else {
    print("Invalid Input")
}


