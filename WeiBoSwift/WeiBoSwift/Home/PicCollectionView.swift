//
//  PicCollectionView.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/20.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit
import SDWebImage
//封装一个picCollectionView自己管理pic的展示
class PicCollectionView: UICollectionView {

    var picUrls : [URL] = [URL](){
        didSet{
            self.reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
}
extension PicCollectionView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath)as! PicCollectionViewCell
        cell.picUrl = picUrls[indexPath.item]
        return cell
    }
   

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath,ShowPhotoBrowserUrlsKey : self.picUrls] as [String : Any]
        NotificationCenter.default.post(name: ShowPhotoBrowserNote, object: self, userInfo: userInfo)
    }
}

extension PicCollectionView : AnimatorPresentedDelegate{
    func startRect(indexPath: IndexPath) -> CGRect {
        //获取cell
        let cell = self.cellForItem(at: indexPath as IndexPath)!
        
        //获取cell的frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: picUrl.absoluteString)
        //计算结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if  y > UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
        
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        
        
        //获取该位置的image对象
        let picULR = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picULR.absoluteString)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    var picUrl : URL? {
        didSet{
            guard let url = picUrl else {
                return
            }
            
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
}
