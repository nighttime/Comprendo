# Comprendo
Python-style list comprehensions in Swift


## Features
* Easily produce expressive arrays and dictionaries
* Generate from any kind of sequence of data
* Simple, flexible semantics allow for a variety of results
* Clean syntax leads to greater readability


## Usage
Comprendo is simple.

It can generate arrays:
##### sequence | {condition} |> {mapping}

And also dictionaries:
##### sequence | {condition} |>> {key map} => {val map}


## Examples
```swift
let nums = [1, 2, 3, 4]
```

Comprendo can scale from a simple mapping...

```swift
let array = nums |> {$0 + 1}
//  array = [2, 3, 4, 5]
```


To complex dictionary patterns.

```swift
let dict = nums | {$0 < 4} | {$0 % 2 == 0} |>> {$0} => {$0 + 1}
//  dict = [2:3]
```


Comprendo can now handle any sequence type!
```swift
let seq = enumerate(nums) | {$0.0 % 2 == 0} |> {$0.1 + 1}
//  seq = [2, 4]
```


_See ComprendoExamples.swift for a variety of use cases!_
