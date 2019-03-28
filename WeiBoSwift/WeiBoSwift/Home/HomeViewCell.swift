//
//  HomeViewCell.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/21.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 15

class HomeViewCell: UITableViewCell {

    var statusVM : StatusViewModel?{
        
        didSet{
            if let viewModel = statusVM {
                iconImage.sd_setImage(with: statusVM?.profileURL)
                vertifyIcon.image = viewModel.verifiedImage
                vipIcon.image = viewModel.vipImage
                userNameLabel.text = viewModel.status.user?.screen_name
                createTimeLabel.text = viewModel.creatTimeStr
                sourceLabel.text = viewModel.sourceText
                let statusText = viewModel.status.text
                contentLab.attributedText = FindEmotion.shareIntance.findAttrString(statusText: statusText, font: UIFont.systemFont(ofSize: 14))
                userNameLabel.textColor = vipIcon.image == nil ? UIColor.black : UIColor.orange//设置用户名文字颜色
                // 计算picView的宽度和高度
                picViewHcons.constant = self.calculatePicViewSize(count: (statusVM?.picURLs.count ?? 0)! ).height
                picViewWCons.constant = self.calculatePicViewSize(count: (statusVM?.picURLs.count ?? 0)! ).width
                picV.picUrls = (statusVM?.picURLs)!
                //设置转发微博的内容
                if let retweetText = statusVM?.status.retweeted_status?.text,let screenName = statusVM?.status.retweeted_status?.user?.screen_name{
                    
                    retweetContentLab.text = "@" + "\(screenName):" + retweetText
                    
                    //设置转发微博背景
                    retweetStatusBgView.isHidden = false
                    
                    //设置转发正文的约束
                    retweetContentBottomCons.constant = 10
                }else{
                    retweetContentLab.text = nil
                    retweetStatusBgView.isHidden = true
                    
                    //设置转发正文的约束
                    retweetContentBottomCons.constant = 0
                }
                
                //手动计算cell高度
                if viewModel.cellHeight == 0{
                    
                    //1.强制布局
                    self.layoutIfNeeded()
                    
                    //2.计算并保存cell高度
                    viewModel.cellHeight = self.bottomToolBarView.frame.maxY
                }
                
                // MARK: - RELabel监听点击
                
                // 监听用户的点击
                contentLab.userTapHandler = { (label, user, range) in
                    print(label)
                    print(user)
                    print(range)
                }
                
                // 监听链接的点击
                contentLab.linkTapHandler = { (label, link, range) in
                    print(label)
                    print(link)
                    print(range)
                }
                
                // 监听话题的点击
                contentLab.topicTapHandler = { (label, topic, range) in
                    print(label)
                    print(topic)
                    print(range)
                }
                
                // 监听用户的点击
                retweetContentLab.userTapHandler = { (label, user, range) in
                    print(label)
                    print(user)
                    print(range)
                }
                
                // 监听链接的点击
                retweetContentLab.linkTapHandler = { (label, link, range) in
                    print(label)
                    print(link)
                    print(range)
                }
                
                // 监听话题的点击
                retweetContentLab.topicTapHandler = { (label, topic, range) in
                    print(label)
                    print(topic)
                    print(range)
                }

            }
        }
    }
    
    @IBOutlet weak var contentLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHcons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetContentBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var vipIcon: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var vertifyIcon: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLab: RELabel!
    
    @IBOutlet weak var picV: PicCollectionView!
    
    @IBOutlet weak var retweetContentLab: RELabel!
    
    @IBOutlet weak var bottomToolBarView: UIView!
    
    @IBOutlet weak var retweetStatusBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //一次性设置内容label的宽度，来以此准确的自动计算label的高度
        contentLabelWidthConstraint.constant = kScreenW - 2 * 15
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeViewCell{
    
    /// 计算picView 的Size
    ///
    /// - Parameter count: 图片数量
    /// - Returns: Size
    fileprivate func calculatePicViewSize(count : Int) -> CGSize{
        
        //1.没有配图
        if count == 0 {
            //修改picView底部约束
            picViewBottomCons.constant = 0
            
            return CGSize.zero
        }
        
        //修改picView底部约束
        picViewBottomCons.constant = 10
        
        //2.取到collectionView的layout
        let layout = picV.collectionViewLayout as! UICollectionViewFlowLayout
        
        //3.单张配图
        if count == 1 {
            
            //3.1取出缓存图片，根据该图片的size进行返回
            let imageUrl = self.statusVM?.picURLs.first?.absoluteString
            
            if let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: imageUrl){
                //3.2设置单张配图的layout.itemSize
                layout.itemSize = CGSize(width: ((image.size.width) * 2) > 150 ? 150 :((image.size.width) * 2), height: (image.size.height) * 2 > 100 ? 100 :(image.size.height) * 2)
                //3.3返回对应的size
                return layout.itemSize
            }
            
        }
        
        // 4.计算多张配图imageView的WH
        let imageViewWH : CGFloat = (kScreenW - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        
        // 5.张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 6.其他张数配图
        let rows = CGFloat((count - 1) / 3 + 1 )
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        let picViewW = kScreenW - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
