//
//  PhotoBrowserController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/25.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import SVProgressHUD

class PhotoBrowserController: UIViewController {

    var indexPath : IndexPath
    var urls : [URL]
    
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关闭")
    fileprivate lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保存")
    init(indexPath : IndexPath,urls : [URL]) {
        self.indexPath = indexPath
        self.urls = urls
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 20;
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // 一进来直接滚动到当前indexPath去
        collectionView.scrollToItem(at: self.indexPath, at: .left, animated: false)
    }
    

}

extension PhotoBrowserController{
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
    }
}

extension PhotoBrowserController {
    @objc fileprivate func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClick(){
        //获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        //将image对象保存相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)),nil)
    }
    
    @objc fileprivate func image(image : UIImage, didFinishSavingWithError error : NSError?,contextInfo : AnyObject){
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        }else{
            showInfo = "保存v成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

extension PhotoBrowserController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        cell.picUrl = urls[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

extension PhotoBrowserController : PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}

extension PhotoBrowserController : AnimatorDismissDelegate {
    
    func indexPathForDimissView() -> IndexPath {
        //获取当前正在显示的indexPath
        let cell = collectionView.visibleCells.first!
        
        return collectionView.indexPath(for: cell)!
    }
    func imageViewForDimissView() -> UIImageView {
        let imageView = UIImageView()
        
        let  cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
}
class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        itemSize = (collectionView?.frame.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
