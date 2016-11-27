//
//  NoteViewController.swift
//  Dictionary
//
//  Created by Lu Ao on 11/20/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase

class NoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let ref = FIRDatabase.database().reference(withPath: "grocery-items")
        let childRef = FIRDatabase.database().reference(withPath: "grocery-items")
        //let text = ["TESTINGGGGGGG","ANOTHERRRRRRRR","HOW ABOUT THIS"]
        let groceryItemRef = childRef.child("Let's do this")
        //groceryItemRef.setValue(text)
        groceryItemRef.observe(.value, with: { snapshot in
        })
    }

}
