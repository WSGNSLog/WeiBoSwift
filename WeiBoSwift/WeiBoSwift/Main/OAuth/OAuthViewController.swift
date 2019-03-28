//
//  OAuthViewController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/21.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        loadWebView()
    }


}

extension OAuthViewController{
    
    fileprivate func setupNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeBtnclick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillBtnclick))
        title = "登录页面"
    }
    
    fileprivate func loadWebView(){
        
        let Url = URL(string: authUrlStr)!
        let request = URLRequest(url: Url)
        webView.loadRequest(request)
        
    }
}

extension OAuthViewController{
    
    @objc fileprivate func closeBtnclick(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillBtnclick(){
        // 执行JS代码实现
        let jsCode = "document.getElementById('userId').value='15369302863';document.getElementById('passwd').value='xiaoyou';"
        
        webView.stringByEvaluatingJavaScript(from: jsCode)

    }
}

extension OAuthViewController : UIWebViewDelegate{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!.absoluteString
        guard url.contains("code=") else {
            //如果不是回调，可以放行
            return true
        }
        let codeRange = url.range(of: "code=")!
        let code = url.substring(from: codeRange.upperBound)
        
        print("**:" + url)
        print("**:" + code)
        
        // 开始请求 access_token
        loadAccessTokenCode(code: code)
        
        // 根据access_token请求用户信息
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
}

extension OAuthViewController{
    
    fileprivate func loadAccessTokenCode(code : String){
        NetworkTools.loadAccessToken(code: code) { (result) in
            print(result!)
            
            //判断错误的情况
            guard result != nil else{
                return
            }
            
            let user = UserAccount(dict: result!)
            
            print(user)
            
            self.loadUserInfo(user: user)
        }
    }
    
    fileprivate func loadUserInfo(user : UserAccount){
        
        NetworkTools.loadUserInfo(accessToken: user.access_token!, uid: user.uid!) { (result) in
            
            //校验
            let userInfoDict = result as! [String :AnyObject]
            
            guard userInfoDict != nil else{return}
            
            user.screen_name = userInfoDict["screen_name"] as? String
            user.avatar_large = userInfoDict["avatar_large"] as? String
            
            //对用户基本信息进行归档
            UserAccountViewModel.shareInstance.archiveAccount(user)
            
            //对用户account属性进行赋值，保证下次取值的时候有
            UserAccountViewModel.shareInstance.account = user
            
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeController()
            })
        }
    }
}
