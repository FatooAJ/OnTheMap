//
//  StudentArray.swift
//  OnTheMap
//
//  Created by Fatima Aljaber on 24/01/2019.
//  Copyright © 2019 Fatima. All rights reserved.
//

import Foundation

struct StrudentArray {
    static var shared = StrudentArray()
    var studentInfoArray = [StudentData]()
    
    init() {
        studentInfoArray = [StudentData]()
    }
    
}
