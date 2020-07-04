//
//  Student.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/3/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

struct Student: Codable {
    var id: String?
    var name: String?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "student_id"
        case name = "student_name"
        case count = "check_in"
    }
}
