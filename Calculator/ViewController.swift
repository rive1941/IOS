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
    
    var brain  = CalculatorBrain()

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
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
        @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false;
            if let result = brain.pushOperand(displayValue){
                displayValue = result
            } else {
                displayValue = 0;
                // want to set this to nil
            }
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

