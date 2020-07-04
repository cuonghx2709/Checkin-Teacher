//
//  APIRouter.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 6/23/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import Alamofire
import UIKit

enum APIRouter: URLRequestConvertible {
    case getCourses(_ email: String)
    case startCheckin(_ codeId: Int)
    case getCheckin(_ courseId: Int)
    case getPhoto(_ courseId: Int,_ studentId: String)
    case sendMessage(_ message: String,_ fromId: String,_ name: String, _ courseId: Int)
    
    var baseURL: String {
        switch self {
        case .getCourses, .startCheckin, .getCheckin, .getPhoto, .sendMessage:
            return APIConfig.baseUrl
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(APIConfig.ContentType.json.rawValue, forHTTPHeaderField: APIConfig.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(APIConfig.ContentType.json.rawValue, forHTTPHeaderField: APIConfig.HttpHeaderField.contentType.rawValue)
        
        // timeout
        urlRequest.timeoutInterval = TimeInterval(30)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    // MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        var params: [String: Any] = [:]
        switch self {
        case .getCourses, .startCheckin, .getCheckin, .getPhoto:
            return params
            
        case .sendMessage(let message, let fromId, let name, _):
            params["message"] = message
            params["fromId"] = fromId
            params["isTeacher"] = true
            params["name"] = name
            return params
        }
    }
    
    // MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .getCourses, .startCheckin, .getCheckin, .getPhoto:
            return .get
        case .sendMessage:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .getCourses(let email):
            return String(format: EndPoint.getCourses, email)
        case .startCheckin(let courseId):
            return String(format: EndPoint.startCheckin, courseId)
        case .getCheckin(let courseId):
            return String(format: EndPoint.getCheckin, courseId)
        case .getPhoto(let courseId, let studentId):
            return String(format: EndPoint.getPhoto, courseId, studentId)
        case .sendMessage(_,_, _, let courseId):
            return String(format: EndPoint.sendMessage, courseId)
        }
    }
}
