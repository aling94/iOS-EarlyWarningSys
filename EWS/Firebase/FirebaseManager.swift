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
    
    func updateUserInfo(uid: String, info: [String: Any], errorHandler: ErrorHandler? = nil) {
        self.dbRef.child("User").child(uid).updateChildValues(info) { (error, _) in
            errorHandler?(error)
        }
    }
    
    func updateCurrentUserInfo(_ info: [String: Any], errorHandler: ErrorHandler? = nil) {
        guard let uid = currentUser?.uid else { return }
        updateUserInfo(uid: uid, info: info, errorHandler: errorHandler)
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
                self.getUserImage(uid) { (image, _) in
                    user.image = image
                    DispatchQueue.global().async(flags: .barrier) {
                        userList.append(user)
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {completion(userList) }
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
        let user = Auth.auth().currentUser!
        let pid = dbRef.child("Post").childByAutoId().key!
        let info: [String : Any] = [
            "pid" : pid,
            "uid" : user.uid,
            "description" : postdesc ?? "" ,
            "timestamp" : Date().timeIntervalSince1970
        ]
        
        dbRef.child("Post").child(pid).setValue(info) { (error, _) in
            if error != nil { errorHandler(error) }
            else { self.savePostImg(id: pid, image: img, errorHandler: errorHandler) }
        }
    }
    
    func getPosts(completion: @escaping ([PostInfo]?) -> Void) {
        var postList: [PostInfo] = []
        let getPostDPG = DispatchGroup()
        let getUserDPG = DispatchGroup()
        dbRef.child("Post").observeSingleEvent(of: .value) { snapshot in
            guard let posts = snapshot.value as? [String : Any] else {
                completion(nil)
                return
            }

            for (pid, data) in posts {
                getPostDPG.enter()
                let post = PostInfo(pid, info: data as! [String : Any])
                getUserDPG.enter()
                
                self.getUserInfo(post.uid) { userInfo in
                    post.user = userInfo
                    getUserDPG.leave()
                }
                
                self.getPostImg(id: pid) { (image, error) in
                    post.image = image
                    getUserDPG.notify(queue: .main) {
                        postList.append(post)
                        getPostDPG.leave()
                    }
                }
            }
            
            getPostDPG.notify(queue: .main) { completion(postList) }
        }
    }
}


// MARK: - Storage
extension FirebaseManager {
    
    func getImage(_ dirName: String, _ imageName: String, completion: @escaping ImageHandler) {
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
    
    func saveUserImage(_ image: UIImage,  errorHander: ErrorHandler? = nil) {
        guard let user = currentUser else { return }
        saveImage(image, "UserImage", user.uid, errorHander: errorHander)
    }
    
    func getUserImage(_ uid: String, completion: @escaping ImageHandler) {
        getImage("UserImage", uid, completion: completion)
    }
    
    // MARK: - Storage - Posts
    
    func savePostImg(id: String, image: UIImage, errorHandler: @escaping ErrorHandler) {
        let fileName = String(describing: id)
        saveImage(image, "Post", fileName, errorHander: errorHandler)
    }
    
    func getPostImg(id : String, completion : @escaping ImageHandler) {
        let fileName = String(describing: id)
        getImage("Post", fileName, completion: completion)
    }
}

