//: Playground - noun: a place where people can play

import UIKit

// Strings must be surrounded by double quotes
var str = "Hello, playground"
// let variables cannot be changed or mutated, they are constants
let const = "This cannot change"

let name = "Dan"

// Combining strings
print("Hello " + name)

// Integers
var a = 8
a * 3
a + 100

// String interpolation
"The variable 'a' has the value \(a)"

let age = 21
print("My name is \(name) and I am \(age) years old")

// Doubles
// Specify the variable type with colon
let b: Double = 1.34
let c: Float = 3.14
let d = 4.3
b/d

// Cannot combine two different number types:
// b/c
// Have to convert first
Float(b)/c

// Booleans
var completed = false;
String(completed)

let myDouble = 5.76
let myInt = 8
print("The product of \(myDouble) and \(myInt) is \(myDouble*Double(myInt))")


// Arrays
var array = [35, 36, 5, 2]
array[0]
array.count
array.append(62)
array.remove(at: 3)
array

var array2 = [3.87, 7.1, 8.9]
array2.remove(at: 1)
// Add product of array elements to ed of array
array2.append(array2.reduce(1, { acc, elem in
    acc * elem
}))

// Arrays can contain values of different types
let mixArray: [Any] = [1, 2.3, "Hello", true, {x in x+2}]

// Can initialise a new types array using the following
let stringArray = [String]()

// Dictionaries
var dict = ["firstname": "Dan", "lastname":"Austin"]
dict["firstname"]
print(dict["lastname"])
dict.count
dict["age"] = "21"
dict

// Can specify the type of dictionary keys and values
var numberToWord = [Int: String]()
numberToWord[3] = "Three"
numberToWord

var menu = ["pizza": 10.99, "ice cream": 4.99, "salad": 7.99]
let totalPrice = menu.reduce(0) { (acc:Double, keyVal:(String, Double)) -> Double in
    acc + keyVal.1
}


// Flow control
let uAge = 13
if uAge >= 18{
    print("You can play our game!")
} else {
    print("Come back in \(18-uAge) years")
}

let uName = "Rob"
if uName == "Rob" {
    print("Welcome!")
}else{
    print("Sorry, \(uName), you cannot play")
}

let entryAllowed = true
if entryAllowed{
    print("Come in!")
}

let username = "Dan"
let password = "pass123"
if username == "Dan" && password == "pass123"{
    print("Logged in")
} else if username == "Dan"{
    print("Password incorrect")
} else if password == "pass123"{
    print("Username incorrect")
} else{
    print("No chance, really")
}
