//
//  Employee.swift
//  SimpleJSON
//
//  Created by Jeff Glasse on 9/3/19.
//  Copyright © 2019 Jeff Glasse. All rights reserved.
//

import Foundation

struct Employee: Codable {
    let id: String
    let employee_name: String
    let employee_salary:  String
    let employee_age: String
    let profile_image: String
}

typealias Employees = [Employee]


