//
//  EndPoint.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 6/23/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import Foundation

struct EndPoint {
    static let getCourses = "/teacher/%@/course"
    static let startCheckin = "/check_in/%d/start/"
    static let getCheckin = "/check_in/course/%d"
    static let getPhoto = "/check_in/photo/%d/%@"
    static let sendMessage = "/message/%d"
 }
