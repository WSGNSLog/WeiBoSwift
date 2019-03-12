//
//  BaseController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/9.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class BaseController: UITableViewController {

    lazy var visitorView : VisitorView = VisitorView.visitorView()
    var isLogin : Bool = false
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.setupNaviItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

   

    
}
extension BaseController{
    private func setupVisitorView() {
        
        view = visitorView
        visitorView.registerBtn.addTarget(self, action: #selector(self.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(self.loginBtnClick), for: .touchUpInside)
    }
    
    private func setupNaviItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(self.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(self.loginBtnClick))
    }
}

extension BaseController{
    @objc private func registerBtnClick(){
        
    }
    @objc private func loginBtnClick(){
        
    }
}
