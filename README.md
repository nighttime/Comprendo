# Comprendo
Python-style list comprehensions in Swift


## Features
* Easily produce expressive arrays and dictionaries
* Simple, flexible semantics allow for a variety of results
* Clean syntax leads to greater readability


## Usage
Comprendo is simple.

It can generate arrays:
##### array ~> {mapping} | when {condition}

And also dictionaries:
##### array ~> {key map} => {val map} | when {condition}


## Examples
```swift
let nums = [1, 2, 3, 4]
```

Comprendo can scale from a simple mapping...

```swift
let array = nums ~> {$0 + 1}
```

_array = [2, 3, 4, 5]_ 

To complex dictionary patterns...

```swift
let dict = nums ~> {$0} => {$0 + 1} | when {$0 < 4} | when {$0 % 2 == 0}
```

_dict = [2:3]_
