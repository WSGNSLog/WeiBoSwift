//
//  HomeController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/5.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
import SVProgressHUD

class HomeController: BaseController {

    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    fileprivate lazy var tipLabel : UILabel = { [unowned self] in

        var tipLabel = UILabel()
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.textAlignment = NSTextAlignment.center
        tipLabel.frame = CGRect(x: 10, y: 10, width: kScreenW - 20, height: 34)
        tipLabel.layer.cornerRadius = 5
        tipLabel.clipsToBounds = true
        tipLabel.isHidden = true
        return tipLabel
    }()
    fileprivate lazy var popoverAnimator :PopoverAnimator = PopoverAnimator{[unowned self](dismissFinished) in
        self.titleBtn.isSelected = dismissFinished
    }
    
    fileprivate lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    var statusViewModels : [StatusViewModel] = [StatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.addRotateionAnimation()
        if !isLogin {
            return
        }
        
        setupNavigationBar()
        
        tableView.estimatedRowHeight = 200;
        
        addRefreshComponent()
        
        setNotifaication()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
}
extension HomeController{
     func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleBtn.setTitle("weibo", for: .normal)
        titleBtn.addTarget(self, action: #selector(self.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

extension HomeController{
    @objc fileprivate func titleBtnClick(titleBtn : TitleButton){
        titleBtn.isSelected = !titleBtn.isSelected
        
        let popoverVC = PopoverController()
        //重要--设置Model样式为保留之前VC们
        popoverVC.modalPresentationStyle = .custom
        //设置转场动画，改变对应的 popvc 的frame
        popoverVC.transitioningDelegate = popoverAnimator
        
        present(popoverVC, animated: true, completion: nil)
    }
    
    fileprivate func setNotifaication(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrower(note:)), name: ShowPhotoBrowserNote, object: nil)
    }
    
    @objc fileprivate func showPhotoBrower(note : Notification){
        let indexPath = note.userInfo?[ShowPhotoBrowserIndexKey] as! IndexPath
        let urls = note.userInfo?[ShowPhotoBrowserUrlsKey] as! [URL]
        let object = note.object as! PicCollectionView
        
        let photoBrowser = PhotoBrowserController(indexPath: indexPath, urls: urls)
        photoBrowser.modalPresentationStyle = .custom
        
        //设置专场代理
        photoBrowser.transitioningDelegate = photoBrowserAnimator
        
        //设置动画代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowser
        present(photoBrowser, animated: true, completion: nil)
    }
}

extension HomeController : UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension HomeController{
    func addRefreshComponent() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadData(true)
        })
        
        
        self.tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: kScreenW - 20, height: 30))
            label.backgroundColor = UIColor.clear
            label.text = "正在加载更多数据..."
            label.textColor = UIColor.gray
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.boldSystemFont(ofSize: 13)
            self.tableView.mj_footer.addSubview(label)
            
            // 请求数据
            self.loadData(false)
        })
    
        self.tableView.mj_header.beginRefreshing()
    }
    
    /// 加载数据
    ///
    /// - Parameter isNewData: 是否加载新数据
    func loadData(_ isNewData: Bool) {
         // 获取since_id / max_id
        var since_id = 0
        var max_id = 0
        
        if isNewData {
            since_id = self.statusViewModels.first?.status.mid ?? 0
        }else{
            max_id = self.statusViewModels.last?.status.mid ?? 0
            max_id = max_id == 0 ? 0 : max_id - 1
        }
        
        NetworkTools.loadHomeData(since_id, max_id: max_id) { (result) in
            
            guard let statusArray = result else{
                
                
                //这块说明没有值，请求超限
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.endRefreshing()
                
                SVProgressHUD.showError(withStatus: "请求超限制次数")
                
                return
            }
            
            var tmpViewModels = [StatusViewModel]()
            
            for dict in statusArray{
                let status = Status(dict: dict)
                
                tmpViewModels.append(StatusViewModel(status: status))
                
            }
            
            if isNewData{
                self.statusViewModels = tmpViewModels + self.statusViewModels
                
                //加载完数据进行图片数据的缓存
                self.cacheImage(isNewData: true, count: tmpViewModels.count, viewModels: self.statusViewModels)
            }else{
                self.statusViewModels += tmpViewModels
                
                //加载完数据进行图片数据的缓存
                self.cacheImage(isNewData: false, count: tmpViewModels.count, viewModels: self.statusViewModels)
                
            }
        }
        
        
    }
    fileprivate func cacheImage(isNewData : Bool, count : Int, viewModels : [StatusViewModel]){
        
        //异步下载图片之后，再进行刷新表格，通过组来完成
        let group = DispatchGroup.init()
        
        for viewModel in viewModels {
            for url in viewModel.picURLs{
                
                group.enter()
                SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil) { (_, _, _, _, _, _) in
                    Mylog("图片下载完")
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            Mylog("刷新数据")
            if isNewData{
                self.showTipLabel(count: count)
            }
        }
    }
    
    fileprivate func showTipLabel(count: Int){
        
        if count == 0 {
            self.tipLabel.text = "无最新微博"
        }else{
            self.tipLabel.text = "更新\(count)条数据"
        }
        
        self.tipLabel.isHidden = false
        let bgview = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        bgview.backgroundColor = UIColor.white
        navigationController?.navigationBar.insertSubview(bgview, at: 0)
        navigationController?.navigationBar.insertSubview(self.tipLabel, at: 0)
        
        UIView.animate(withDuration: 1.5, animations: {
            // 慢慢展示
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: 44)
        }) { (_) in
            // 慢慢消失
            UIView.animate(withDuration: 1.5, delay: 1.0, options: [], animations: {
                self.tipLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

extension HomeController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeViewCell
        cell.statusVM = self.statusViewModels[indexPath.row]
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //手动计算cell高度
        
        let viewModel = self.statusViewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
}
