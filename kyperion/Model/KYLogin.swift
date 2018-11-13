//
//  KYLogin.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import UIKit

class KYLogin {
    var username: String
    var password: String
    var token: String

    init(){
        self.username = ""
        self.password = ""
        self.token = ""
    }
    
    init(username:String, password:String, token:String){
        self.username = username
        self.password = password
        self.token = token
    }
    
    init(login:Login){
        self.username = login.username
        self.password = login.password
        self.token = login.token
    }
    
    var loginStruct: Login {
        return Login(username: self.username, password: self.password, token:self.token)
    }
    
    var description: String {
        return "Username: \(self.username), password: \(self.password), token: \(self.token)\n"
    }
    
    var encryptPwd : String {
        var pwd = ""
        var counter = 0
        while(counter<password.length){
            pwd = pwd + "*"
            counter++
        }
        return pwd
    }
    
}