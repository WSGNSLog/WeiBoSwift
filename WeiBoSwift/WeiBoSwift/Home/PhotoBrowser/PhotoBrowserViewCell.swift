//
//  PhotoBrowserViewCell.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/25.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit
import SDWebImage

let PhotoBrowserCell = "PhotoBrowserCell"

protocol PhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
}
class PhotoBrowserViewCell: UICollectionViewCell {
    
    var picUrl : URL?{
        didSet{
            setupContent(picURL: picUrl)
        }
    }
    
    var delegate : PhotoBrowserViewCellDelegate?
    
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    fileprivate lazy var progressView : ProgressView =  ProgressView()
    lazy var imageView : UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension PhotoBrowserViewCell{
    
    fileprivate func setupUI(){
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
    }
    
    
}

extension PhotoBrowserViewCell{
    @objc fileprivate func imageViewClick(){
        delegate?.imageViewClick()
    }
}

extension PhotoBrowserViewCell {
    fileprivate func setupContent(picURL : URL?){
        //nil值校验
        guard let picURL = picURL else {
            return
        }
        
        //取出image对象
        let  image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        //计算imageView的frame
        let width = UIScreen.main.bounds.width
        let height = width / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        
        //设置imageView的图片
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigUrl(picUrl!), placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        
        //设置scrollView的contentSize
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    private func getBigUrl(_ smallURL : URL) -> URL {
        let smallURLString = smallURL.absoluteString
        let bigURLString = (smallURLString as NSString).replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigURLString)!
        
    }
}
