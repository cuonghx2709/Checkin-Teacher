//
//  NetworkingManager.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 6/23/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

struct NetworkingManager {
    // MARK: - The request function to get results in an Observable
    static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        //Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<T>.create { observer in
            //Trigger the HttpRequest using AlamoFire (AF)
            let request = AF.request(urlConvertible).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    //Everything is fine, return the value in onNext
                    guard let jsondData = try? JSONSerialization.data(withJSONObject: value, options: []),
                        let data = try? JSONDecoder().decode(T.self, from: jsondData) else {
                            observer.onError(APIError.error(APIError.parsingDataErrorCode))
                            return
                    }
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    //Something went wrong, switch on the status code and return the error
                    if let statusCode = response.response?.statusCode {
                        observer.onError(APIError
                            .error(statusCode))
                        return
                    }
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
