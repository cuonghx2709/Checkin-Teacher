//
//  NetworkingManager+ext.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 6/23/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - API
struct APIClient {
    
    static func getCourses(email: String) -> Observable<[Course]> {
        return NetworkingManager.request(APIRouter.getCourses(email))
    }
    
    static func checkin(id: Int) -> Observable<BaseResponse> {
        return NetworkingManager.request(APIRouter.startCheckin(id))
    }
    
    static func getCheckin(courseId: Int) -> Observable<[Student]> {
        return NetworkingManager.request(APIRouter.getCheckin(courseId))
    }
    
    static func getPhoto(courseId: Int, studentId: String) -> Observable<[Photo]> {
        return NetworkingManager.request(APIRouter.getPhoto(courseId, studentId))
    }
    
    static func sendMessage(message: String, fromId: String, name: String, courseId: Int) -> Observable<BaseResponse> {
        return NetworkingManager.request(APIRouter.sendMessage(message, fromId, name, courseId))
    }
}
