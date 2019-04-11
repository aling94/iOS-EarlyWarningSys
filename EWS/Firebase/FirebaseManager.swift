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
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}
    
    let dbRef = Database.database().reference()
    let stRef = Storage.storage().reference()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var currentUserInfo: UserInfo?
}

// MARK: - Authentication
extension FirebaseManager {
    func loginUser(email: String, passw: String, errorHandler: ErrorHandler? = nil) {
        Auth.auth().signIn(withEmail: email, password: passw) { (result, error) in
            errorHandler?(error)
        }
    }
    
    func registerUser(email: String, passw: String, info: [String: Any], completion: AuthHandler? = nil) {
        Auth.auth().createUser(withEmail: email, password: passw) { (result, error) in
            if error == nil {
                guard let user = result?.user else { return }
                self.updateUserInfo(uid: user.uid, info: info)
                completion?(result, nil)
            } else {
                completion?(nil, error)
            }
        }
    }
    
    func signoutUser() {
        try? Auth.auth().signOut()
    }
    
    func resetPassword(email: String, errorHandler: ErrorHandler? = nil) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            errorHandler?(error)
        }
    }
}

// MARK: - Database
extension FirebaseManager {
    func updateUserInfo(uid: String, info: [String: Any]) {
        self.dbRef.child("User").child(uid).updateChildValues(info)
    }
    
    func updateCurrentUserInfo(_ info: [String: Any]) {
        guard let uid = currentUser?.uid else { return }
        self.dbRef.child("User").child(uid).updateChildValues(info)
    }
    
    func getUserInfo(_ user: User, completion: @escaping (UserInfo) -> Void) {
        dbRef.child("User").child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userObj = snapshot.value as? [String: Any] else { return }
            let userInfo = UserInfo(user.uid, info: userObj)
            completion(userInfo)
        }
    }
    
    func getCurrentUserInfo(completion: @escaping (UserInfo) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        getUserInfo(user, completion: completion)
    }
    
    func getUsers(completion: @escaping ([UserInfo]) -> Void) {
        dbRef.child("User").observeSingleEvent(of: .value) { (snapshot) in
            guard let usersDict = snapshot.value as? [String: Any] else { return }
            let dispatchGroup = DispatchGroup()
            
            var userList: [UserInfo] = []
            for (uid, data) in usersDict {
                dispatchGroup.enter()
                let user = UserInfo(uid, info: data as! [String: Any])
                userList.append(user)
                self.getUserImage(uid) { (image, _) in
                    user.image = image
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) { completion(userList) }
            
        }
    }
}

// MARK: - Storage
extension FirebaseManager {
    func saveUserImage(_ image: UIImage) {
        guard let user = currentUser else { return }
        let imgData = image.jpegData(compressionQuality: 0 )
        let metaData = StorageMetadata()
        metaData.contentType = "Image/jpeg"
        let imgName = "UserImage/\(user.uid).jpeg"
        stRef.child(imgName).putData(imgData!, metadata: metaData) { _, error in
            
        }
        
    }
    
    func getUserImage(_ uid: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let imageName = "UserImage/\(uid).jpeg"
        stRef.child(imageName).getData(maxSize: 300*300) { (data, error) in
            if let data = data { completion(UIImage(data: data), nil) }
            else { completion(nil, error)}
        }
    }
}
