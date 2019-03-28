//
//  WelcomeController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/21.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconBottomConstrant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        iconView.sd_setImage(with: URL(string: (UserAccountViewModel.shareInstance.account?.avatar_large) ?? ""), placeholderImage: UIImage(named: "avatar_default"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.iconBottomConstrant.constant = UIScreen.main.bounds.size.height - 250
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

}
