//
//  ViewController.swift
//  Comprendo
//
//  Created by Nick McKenna on 10/12/14.
//  Copyright (c) 2014 nighttime software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let t = Tests()
        t.doTests()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

