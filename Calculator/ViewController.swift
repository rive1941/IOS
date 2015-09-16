//
//  ViewController.swift
//  Calculator
//
//  Created by Maria G Rivera on 9/1/15.
//  Copyright (c) 2015 Maria G Rivera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle! // var is the same as let except it's a constant
        // optional: not set (nil), set to something?
        // exclamation point at end of currentTitle unwraps the optional or crashes if it's nil
        if userIsInTheMiddleOfTypingANumber {
        display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true;
            
        }
        //println("Digit = \(digit)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        switch operation{
        case "✕": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperationOnAValue { sqrt($0) }
        case "Cos": performOperationOnAValue { cos($0) }
        case "Sin": performOperationOnAValue { sin($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperationOnAValue(operation: (Double) -> Double){
        if (operandStack.count >= 1) {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
// we can move this function to case"X": so we don't have repeated functions for /, + and -
//    func multiply(op1: Double, op2: Double) -> Double{
//        return op1 * op2
//    }
    
    var operandStack: Array<Double> = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false;
        operandStack.append(displayValue)
        println("operand stack = \(operandStack)")
    }
    
    
    @IBAction func clear() {
        display.text! = "0"
        operandStack.removeAll()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false;
        }
    }
    
}

