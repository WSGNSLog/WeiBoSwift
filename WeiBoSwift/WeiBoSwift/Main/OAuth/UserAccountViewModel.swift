//
//  UserAccountViewModel.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/21.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class UserAccountViewModel: NSObject {

    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    
    var account : UserAccount?
    
    var accountPath : String {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path = (path as NSString).strings(byAppendingPaths: ["account.plist"]).first!
        
        print("sandboxPath: " + path)
        return path
    }
    
    var isLogin : Bool {
        
         // 如果没有读到 account 信息直接 false
        guard let userAccount = account else {
            return false
        }
        //        if let expiresDate = userAccount.expires_date {
        //
        //            if expiresDate.compare(Date()) == ComparisonResult.orderedDescending {
        //                return true
        //            }else{
        //                return false
        //            }
        //
        //        }else {
        //            return false
        //        }
        guard let expiresDate = userAccount.expires_date else {
            return false
        }
        if expiresDate.compare(Date()) == ComparisonResult.orderedDescending {
            return true
        }else{
            return false
        }
    }
    
    override init() {
        super.init()
        
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
    
    func archiveAccount(_ account : UserAccount) {
        NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
    }
}
