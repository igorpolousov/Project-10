//
//  Person.swift
//  Project 10
//
//  Created by Igor Polousov on 12.08.2021.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
     init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
