//
//  PicPickerCell.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/28.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {

    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage?{
        didSet{
            //让btn展示对应的图片
            if image != nil {
                imageView.image = image
                addBtn.isUserInteractionEnabled = false
                deleteBtn.isHidden = false
            }else{
                imageView.image = UIImage(named: "compose_pic_add")
                addBtn.isUserInteractionEnabled = true
                deleteBtn.isHidden = true
            }
        }
    }
    
    @IBAction func addPicBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: picPickerAddPhotoNote, object: nil)
    }
    
    @IBAction func deletePicBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: picPickerDeletePhotoNote, object: imageView.image)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
}

extension PicPickerCell{
    
    
}
