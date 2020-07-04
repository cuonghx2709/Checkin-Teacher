//
//  Course.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/2/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

struct Course: Codable {
    var id: Int?
    var name: String?
    var code: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "course_id"
        case name = "course_name"
        case code = "code"
    }
}
