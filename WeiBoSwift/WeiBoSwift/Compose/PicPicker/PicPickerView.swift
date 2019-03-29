//
//  PicPickerView.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/29.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

private let picPickerCellID = "picPickerCellID"
private let margin : CGFloat = 15

class PicPickerView: UICollectionView {

    //MARK: - 属性
    var images : [UIImage] = [UIImage](){
        didSet{
            reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        
        setupItemLayout()
        
        self.register(UINib(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: picPickerCellID)
    }
}

extension PicPickerView{
    fileprivate func setupItemLayout(){
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemW = (kScreenW - 4 * margin) / 3
        let itemH = itemW
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        self.contentInset = UIEdgeInsetsMake(margin, margin, 0, margin)
    }
}

extension PicPickerView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCellID, for: indexPath) as! PicPickerCell
        
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
}
