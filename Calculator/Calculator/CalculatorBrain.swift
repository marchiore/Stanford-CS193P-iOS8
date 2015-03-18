//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Matheus Marchiore on 3/11/15.
//  Copyright (c) 2015 Matheus Marchiore. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Constant(String, Double)
        
        var description: String {
            get{
                switch self {
                case .Operand( let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Constant(_, let operand):
                    return "\(operand)"
                }
            }
        }
    }
    
    private var opStack = Array<Op>()
    //alternativa para instanciar um array
    //var opStack = [Op]()
    
    private var knownOps = Dictionary<String, Op>()
    //alternativa
    //var knowOps = [String:Op]()

    //Construtor
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("ⅹ", *))
        //knownOps["ⅹ"] = Op.BinaryOperation("ⅹ", *)
        knownOps["÷"] = Op.BinaryOperation("÷", {$1 / $0})
        knownOps["+"] = Op.BinaryOperation("+", {$0 + $1})
        knownOps["-"] = Op.BinaryOperation("-", {$1 - $0})
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["SIN"] = Op.UnaryOperation("SIN", sin)
        knownOps["COS"] = Op.UnaryOperation("COS", cos)
        knownOps["π"] = Op.Constant("π", M_PI)
    }
    
    //let antes do ops significa que ele nao é uma copia e sim READ-ONLY
    //var faz uma copia e deixa ele mutavel, mas sem referencia com o original
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        //verifica se ele não está vazio
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Constant(_, let operand):
                return (operand, remainingOps);
            }
        }
        return (nil, ops)
    }
    
    
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        //let (result, _) = evaluate(opStack)  pode colocar o _ no lugar do remainder
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand));
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func cleanStack(){
        opStack = Array<Op>()
    }
    
    func printStack() -> String{
        var array = opStack
        var sRetorno : String = ""
        for element in array {
            sRetorno += "\(element.description) "
        }
        return sRetorno
    }
}
