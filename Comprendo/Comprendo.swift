//
//  Comprehension.swift
//  Comprehension
//
//  Created by Nick McKenna on 10/10/14.
//  Copyright (c) 2014 nighttime software. All rights reserved.
//

import Foundation

// Example Usage

//  [V]  = collection ~> {T -> V}
//  [V]  = collection ~> {T -> V} | when {T -> Bool}
//  [V]  = collection ~> {T -> V} | when {T -> Bool} | when {T -> Bool}

// [K:V] = collection ~> {T -> K} => {T -> V}
// [K:V] = collection ~> {T -> K} => {T -> V} | when {T -> Bool}
// [K:V] = collection ~> {T -> K} => {T -> V} | when {T -> Bool} | when {T -> Bool}

// T = Type of Collection e.g. [T]
// K = Type of Stored Key
// V = Type of Stored Value


infix operator ~> { associativity left precedence 10 }

infix operator => { associativity left precedence 20 }

infix operator |  { associativity left precedence 20 }


class ArrayEntryPattern<T, V> {
    var valFunc:(T) -> (V)
    var inclusionFuncs:[(T) -> (Bool)] = []
    
    init(valFunc:(T) -> (V), inclusionFunc:((T) -> (Bool))?) {
        self.valFunc = valFunc
        if let inc = inclusionFunc {
            self.inclusionFuncs.append(inc)
        }
    }
}

class DictEntryPattern<T, K:Hashable, V>: ArrayEntryPattern<T, V> {
    var keyFunc:(T) -> (K)
    
    init(keyFunc:(T) -> (K), valFunc:(T) -> (V), inclusionFunc:((T) -> (Bool))?) {
        self.keyFunc = keyFunc
        super.init(valFunc:valFunc, inclusionFunc:inclusionFunc)
    }
}


func => <T, K:Hashable, V> (left:(T) -> (K), right:(T) -> (V)) -> DictEntryPattern<T, K, V> {
    return DictEntryPattern(keyFunc:left, valFunc:right, inclusionFunc:nil)
}

func | <T, V> (left:(T) -> (V), right:(T) -> (Bool)) -> ArrayEntryPattern<T, V> {
    return ArrayEntryPattern(valFunc:left, inclusionFunc:right)
}

func | <T, V> (var left:ArrayEntryPattern<T, V>, right:(T) -> (Bool)) -> ArrayEntryPattern<T, V> {
    left.inclusionFuncs.append(right)
    return left
}

func | <T, K:Hashable, V> (var left:DictEntryPattern<T, K, V>, right:(T) -> (Bool)) -> DictEntryPattern<T, K, V> {
    left.inclusionFuncs.append(right)
    return left
}

func when<T>(filter:(T) -> (Bool)) -> (T) -> (Bool) {
    return filter
}

func ~> <T, V> (left:[T], right:(T) -> (V)) -> [V] {
    return left.map(right)
}

func ~> <T, V> (left:[T], right:ArrayEntryPattern<T, V>) -> [V] {
    var accumulator:[V] = []
    
    iter: for item in left {
        for f in right.inclusionFuncs {
            if !f(item) {
                continue iter
            }
        }
        accumulator.append(right.valFunc(item))
    }
    
    return accumulator
}

func ~> <T, K:Hashable, V> (left:[T], right:DictEntryPattern<T, K, V>) -> [K:V] {
    var accumulator:[K:V] = [:]
    
    iter: for item in left {
        for f in right.inclusionFuncs {
            if !f(item) {
                continue iter
            }
        }
        accumulator[right.keyFunc(item)] = right.valFunc(item)
    }
    
    return accumulator
}

