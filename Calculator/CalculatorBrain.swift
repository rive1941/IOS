//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Maria G Rivera on 9/30/15.
//  Copyright (c) 2015 Maria G Rivera. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable{ // enum implements whatever is in the protocol like "Printable" 
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol,_):
                    return symbol
                }
            }
        }
        
    }
    
    // not prefered syntax: var opStack =  Array<Op>()
    private var opStack = [Op]()
    
    //var knownOps = Dictionary<String, Op>() // Dictionary<Key Type, Value type>
    private var knownOps = [String:Op]() // same as dictionary above
    
    init() {
        knownOps["✕"] = Op.BinaryOperation("✕", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.BinaryOperation("√") { sqrt($0) }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
                // don't need default because all cases of the enum have been covered
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack) // let a tuple = the result
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String){
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}