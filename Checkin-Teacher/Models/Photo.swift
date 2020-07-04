//
//  Photo.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/3/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

struct Photo: Codable {
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "upload_link"
    }
}
