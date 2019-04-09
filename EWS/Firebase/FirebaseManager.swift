//
//  FirebaseManager.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import Firebase

import FirebaseAuth
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}
    
    let ref = Database.database().reference()
    
    func registerUser(email: String, passw: String, info: [String: String], completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: passw) { (result, error) in
            if error == nil {
                guard let user = result?.user else { return }
                self.updateUserInfo(uid: user.uid, info: info)
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func updateUserInfo(uid: String, info: [String: String]) {
        self.ref.child("User").child(uid).setValue(info)
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
}


// MARK: - Authentication
extension FirebaseManager {
    
    
}
