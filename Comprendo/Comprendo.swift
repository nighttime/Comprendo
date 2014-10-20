//
//  Comprehension.swift
//  Comprehension
//
//  Created by Nick McKenna on 10/10/14.
//  Copyright (c) 2014 nighttime software. All rights reserved.
//

import Foundation

// T = Type of Collection e.g. [T]
// K = Type of Stored Key
// V = Type of Stored Value

// [V] = collection |> {T -> V}
// [V] = collection | when {T -> Bool} |> {T -> V}
// [V] = collection | when {T -> Bool} | when {T -> Bool} |> {T -> V}

// T:SequenceType |> {T.Gen.Ele -> V} = [V]
// T:SequenceType | when {T.Gen.Ele -> Bool} = ConditionedCollection
// ConditionedCollection | when {T.Gen.Ele -> Bool} = ConditionedCollection
// ConditionedCollection |> {T.Gen.Ele -> V} = [V]


// [K:V]  = collection |>> {T -> K} => {T -> V}
// [K:V]  = collection | when {T -> Bool} |>> {T -> K} => {T -> V}
// [K:V]  = collection | when {T -> Bool} | when {T -> Bool} |>> {T -> K} => {T -> V}

// T:SequenceType |>> {T.Gen.Ele -> K} = PartialDictComprehension
// PartialDictComprehension => {T.Gen.Ele -> V} = [K:V]
// T:SequenceType | when {T.Gen.Ele -> Bool} = ConditionedCollection
// ConditionedCollection | when {T.Gen.Ele -> Bool} = ConditionedCollection
// ConditionedCollection |>> {T.Gen.Ele -> K} = PartialDictComprehension



infix operator |>  { associativity left precedence 133 }

infix operator |>> { associativity left precedence 133 }

infix operator =>  { associativity left precedence 133 }

infix operator |   { associativity left precedence 133 }


class ConditionedCollection<T:SequenceType, V> {
    var sequence:T
    var inclusionFuncs:[(T.Generator.Element) -> Bool] = []
    init(sequence:T, inclusionFunc:(T.Generator.Element) -> Bool) {
        self.sequence = sequence
        self.inclusionFuncs.append(inclusionFunc)
    }
}

class PartialDictComprehension<T:SequenceType, K:Hashable, V> {
    var sequence:T
    var inclusionFuncs:[(T.Generator.Element) -> Bool] = []
    var keyFunc:(T.Generator.Element) -> K
    init(conditionedCollection:ConditionedCollection<T, V>, keyFunc:(T.Generator.Element) -> K) {
        self.sequence = conditionedCollection.sequence
        self.inclusionFuncs = conditionedCollection.inclusionFuncs
        self.keyFunc = keyFunc
    }
    init(collection:T, keyFunc:(T.Generator.Element) -> K) {
        self.sequence = collection
        self.keyFunc = keyFunc
    }
}


func |> <T:SequenceType, V> (left:T, right:(T.Generator.Element) -> V) -> [V] {
    return map(left, right)
}

func |> <T:SequenceType, V> (left:ConditionedCollection<T, V>, right:(T.Generator.Element) -> V) -> [V] {
    var accum:[V] = []
    iter: for item in left.sequence {
        for f in left.inclusionFuncs {
            if !f(item) {
                continue iter
            }
        }
        accum.append(right(item))
    }
    return accum
}

func |>> <T:SequenceType, K:Hashable, V> (left:T, right:(T.Generator.Element) -> K) -> PartialDictComprehension<T, K, V> {
    return PartialDictComprehension(collection:left, keyFunc:right)
}

func |>> <T:SequenceType, K:Hashable, V> (left:ConditionedCollection<T, V>, right:(T.Generator.Element) -> K) -> PartialDictComprehension<T, K, V> {
    return PartialDictComprehension(conditionedCollection:left, keyFunc:right)
}


func | <T:SequenceType, V> (left:T, right:(T.Generator.Element) -> Bool) -> ConditionedCollection<T, V> {
    return ConditionedCollection(sequence:left, inclusionFunc:right)
}

func | <T:SequenceType, V> (left:ConditionedCollection<T, V>, right:(T.Generator.Element) -> Bool) -> ConditionedCollection<T, V> {
    left.inclusionFuncs.append(right)
    return left
}

func => <T:SequenceType, K:Hashable, V> (left:PartialDictComprehension<T, K, V>, right:(T.Generator.Element) -> V) -> [K:V] {
    var accum:[K:V] = [:]
    iter: for item in left.sequence {
        for f in left.inclusionFuncs {
            if !f(item) {
                continue iter
            }
        }
        accum[left.keyFunc(item)] = right(item)
    }
    return accum
}
