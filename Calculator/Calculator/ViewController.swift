//
//  ViewController.swift
//  Calculator
//
//  Created by Matheus Marchiore on 2/11/15.
//  Copyright (c) 2015 Matheus Marchiore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func append(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && display.text?.rangeOfString(".") != nil{
            return
        }
        
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
            
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    //Criando o array para armazenar os operandos
    
    var operandStack: Array<Double> = Array<Double>()
    // a linha acima pode ser escrita
    // var operandStack: Array<Double> = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }else {
            displayValue = 0
        }
        updateHistory()
        
        /*
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
        */
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        updateHistory()
        
        /*
        switch operation{

        case "ⅹ": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "-": performOperation {$1 - $0}
        case "√": performOperation {sqrt($0)}
            
        default: break
        
        }

        */
        
    }
   
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double) -> Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    @IBAction func cleanDisplay(sender: UIButton) {
        brain.cleanStack()
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0"
        
    }
    
    func updateHistory(){
        history.text = brain.printStack()
    }

    @IBAction func backspace(sender: AnyObject) {
        if display.text! == ""{
            return
        }
        var sTextoDisplay : String = display.text!
        display.text = dropLast(display.text!)
    }
}

