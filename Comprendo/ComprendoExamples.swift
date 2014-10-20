//
//  ComprendoExamples.swift
//  Comprendo
//
//  Created by Nick McKenna on 10/12/14.
//  Copyright (c) 2014 nighttime software. All rights reserved.
//

import Foundation


struct Tests {
    
    func doTests() {
        let nums = [1, 2, 3, 4]
        
        // Each of the below prints [2, 3, 4, 5]
        
        let nums1 = nums |> {$0 + 1}
        println(nums1)
        
        let nums2 = stride(from: 1, through: 4, by: 1) |> {$0 + 1}
        println(nums2)
        
        let nums3 = (1..<5) |> {$0 + 1}
        println(nums3)
        
        let nums4 = enumerate(nums) |> {$0.1 + 1}
        println(nums4)
        
        // Conditionally print only when index is even
        // Prints [3, 5]
        
        let nums5 = enumerate(nums) | {$0.0 % 2 == 0} |> {$0.1 + 1}
        println(nums5)
        
        // Prints [0:2, 1:3, 2:4, 3:5]
        
        let nums6 = enumerate(nums) |>> {$0.1} => {$0.1 + 1}
        println(nums6)
        
        // Conditionally print only when num is even
        // Prints [1:3, 3:5]
        
        let nums7 = enumerate(nums) | {$0.1 % 2 == 0} |>> {$0.0} => {$0.1 + 1}
        println(nums7)
    }
    
}