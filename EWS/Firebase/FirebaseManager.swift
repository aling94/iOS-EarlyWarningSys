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
    
    let ref = Database.database().reference()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
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
        self.ref.child("User").child(uid).setValue(info)
    }
    
    func getUsers(completion: (([UserInfo]) -> Void)? = nil  ) {
        ref.child("User").observe(.value) { (snapshot) in
            guard let usersDict = snapshot.value as? [String: Any] else { return }
            let users: [UserInfo] = usersDict.map { (uid, data) in
                let info = data as! [String: String]
                return UserInfo(uid, info: info)
            }
            completion?(users)
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
        var storageRef = Storage.storage().reference()
        storageRef = storageRef.child(imgName)
        storageRef.putData(imgData!, metadata: metaData)
    }
    
    func loadUserImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let user = currentUser else {
            completion(nil, nil)
            return
        }
        let imagename = "UserImage/\(user.uid).jpeg"
        var storageRef = Storage.storage().reference()
        storageRef = storageRef.child(imagename)
        storageRef.getData(maxSize: 300*300) { (data, error) in
            if let data = data {
                let img = UIImage(data: data)
                completion(img, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
