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
    
    func updatePassword(_ newPass: String, errorHandler: @escaping ErrorHandler) {
        currentUser?.updatePassword(to: newPass, completion: errorHandler)
    }
}


// MARK: - Database
extension FirebaseManager {
    
    // MARK: - Database/User
    
    func updateUserInfo(uid: String, info: [String: Any]) {
        self.dbRef.child("User").child(uid).updateChildValues(info)
    }
    
    func updateCurrentUserInfo(_ info: [String: Any]) {
        guard let uid = currentUser?.uid else { return }
        self.dbRef.child("User").child(uid).updateChildValues(info)
    }
    
    func getUserInfo(_ uid: String, completion: @escaping (UserInfo?) -> Void) {
        dbRef.child("User").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userObj = snapshot.value as? [String: Any] else { return }
            let userInfo = UserInfo(uid, info: userObj)
            self.getUserImage(uid) { (image, _) in
                userInfo.image = image
                completion(userInfo)
            }
        }
    }
    
    func getCurrentUserInfo(completion: @escaping (UserInfo?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        getUserInfo(user.uid) { userInfo in
            self.currentUserInfo = userInfo
            completion(userInfo)
        }
    }
    
    func getUsers(_ blacklist: [String] = [], completion: @escaping ([UserInfo]?) -> Void) {
        dbRef.child("User").observeSingleEvent(of: .value) { (snapshot) in
            guard let usersDict = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var userList: [UserInfo] = []
            
            for (uid, data) in usersDict {
                if blacklist.contains(uid) { continue }
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
    
    func addFriend(_ friendID: String, errorHandler: @escaping ErrorHandler) {
        guard let uid = currentUser?.uid else { return }
        let info: [String : Any] = [friendID : true]
        self.dbRef.child("User").child(uid).child("friends").updateChildValues(info) { error, _ in
            errorHandler(error)
        }
    }
    
    func removeFriend(_ friendID: String, errorHandler: @escaping ErrorHandler) {
        guard let uid = currentUser?.uid else { return }
        self.dbRef.child("User").child(uid).child("friends").child(friendID).removeValue() { error, _ in
            errorHandler(error)
        }
        
    }
    
    func getFriends(completion: @escaping ([UserInfo]?) -> Void) {
        guard let uid = currentUser?.uid else {
            completion(nil)
            return
        }
        
        dbRef.child("User").child(uid).child("friends").observeSingleEvent(of: .value) { (snapshot) in
            guard let friends = snapshot.value as? [String : Any] else {
                completion(nil)
                return
            }
            let dispatchGroup = DispatchGroup()
            var friendInfoList: [UserInfo] = []
            
            for friend in friends {
                dispatchGroup.enter()
                self.getUserInfo(friend.key) { userInfo in
                    friendInfoList.append(userInfo!)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) { completion(friendInfoList) }
        }
    }
    
    // MARK: - Database/Post
    
    func addPost(img : UIImage , postdesc : String? , errorHandler: @escaping ErrorHandler) {
        let user = Auth.auth().currentUser
        let postKey = dbRef.child("Post").childByAutoId().key!
        let info = [
            "uid" : user?.uid,
            "description" : postdesc ?? "" ,
            "timestamp" : "\(Date().timeIntervalSince1970)"
        ]
        
        dbRef.child("Post").child(postKey).setValue(info) { (error, _) in
            if error != nil { errorHandler(error) }
            else { self.savePostImg(id: postKey, image: img, errorHandler: errorHandler) }
        }
    }
}


// MARK: - Storage
extension FirebaseManager {
    
    func getImage(_ dirName: String, _ imageName: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let imageName = "\(dirName)/\(imageName).jpeg"
        stRef.child(imageName).getData(maxSize: 300*300) { (data, error) in
            if let data = data { completion(UIImage(data: data), nil) }
            else { completion(nil, error)}
        }
    }
    
    
    
    
    func saveImage(_ image: UIImage, _ dirName: String, _ imageName: String, errorHander: ErrorHandler? = nil) {
        let imgData = image.jpegData(compressionQuality: 0 )
        let metaData = StorageMetadata()
        metaData.contentType = "Image/jpeg"
        let imageName = "\(dirName)/\(imageName).jpeg"
        stRef.child(imageName).putData(imgData!, metadata: metaData) { _, error in errorHander?(error) }
    }
    
    // MARK: - Storage/UserImage
    
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
        getImage("UserImage", uid, completion: completion)
//        let imageName = "UserImage/\(uid).jpeg"
//        stRef.child(imageName).getData(maxSize: 300*300) { (data, error) in
//            if let data = data { completion(UIImage(data: data), nil) }
//            else { completion(nil, error)}
//        }
    }
    
    // MARK: - Storage - Posts
    
    func savePostImg(id: String, image: UIImage, errorHandler: @escaping ErrorHandler) {
        let imgData = image.jpegData(compressionQuality: 0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imgName = "Post/\(String(describing: id)).jpeg"
        stRef.child(imgName).putData(imgData!, metadata: metaData) { (data, error) in
            errorHandler(error)
        }
    }
    
    func getPostImg(id : String, completion : @escaping (UIImage?, Error?) -> Void) {
        getImage("Post", id, completion: completion)
//        let imageName = "Post/\(String(describing: id)).jpeg"
//        stRef.child(imageName).getData(maxSize: 1*300*300) { (data, error) in
//            if let data = data { completion(UIImage(data: data), nil) }
//            else { completion(nil, error)}
//        }
    }
}

