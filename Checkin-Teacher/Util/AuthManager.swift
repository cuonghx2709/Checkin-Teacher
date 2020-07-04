//
//  AuthManager.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/2/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

struct SupportAuthManager {
    static let shared = SupportAuthManager()
    
    func getEmail() -> String? {
        guard let auth = Auth.auth().currentUser else { return nil }
        for userInfor in auth.providerData {
            if let email = userInfor.email {
                return email
            }
        }
        return nil
    }
}
