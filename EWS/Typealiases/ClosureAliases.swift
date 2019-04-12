//
//  ClosureAliases.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//
import FirebaseAuth

typealias ErrorHandler = (Error?) -> Void
typealias AuthHandler = (AuthDataResult?, Error?) -> Void
typealias ImageHandler = (UIImage?, Error?) -> Void
