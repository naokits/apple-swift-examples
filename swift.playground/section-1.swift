// Playground - noun: a place where people can play

// iBoosで紹介されているコードを実際に実行してみるだけのプレイグラウンドです

import Cocoa

var str = "Hello, playground"


// Simple Values p6

/*
Use let to make a constant and var to make a variable. The value of a constant doesn’t need to be known at compile time, but you must assign it a value exactly once. This means you can use constants to name a value that you determine once but use in many places.
*/
var myVariable = 42
myVariable = 50
let myConstant = 42

/*
A constant or variable must have the same type as the value you want to assign to it. However, you don’t always have to write the type explicitly. Providing a value when you create a constant or variable lets the compiler infer its type. In the example above, the compiler infers that myVariable is an integer because its initial value is a integer.
*/


/*
If the initial value doesn’t provide enough information (or if there is no initial value), specify the type by writing it after the variable, separated by a colon.

“EXPERIMENT

Create a constant with an explicit type of Float and a value of 4.”

抜粋：: Apple Inc. “The Swift Programming Language”。 iBooks. https://itun.es/jp/jEUH0.l
*/
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70



let label = "The width is "
let width = 94
let widthLabel = label + String(width)



