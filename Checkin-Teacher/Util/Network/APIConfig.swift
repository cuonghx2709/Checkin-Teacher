//
//  APIConfig.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 6/23/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import Foundation

struct APIConfig {
    static var baseUrl: String {
        return "http://192.168.100.3:5050"
    }
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
    
}
