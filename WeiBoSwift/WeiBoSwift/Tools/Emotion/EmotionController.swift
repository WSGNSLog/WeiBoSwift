//
//  EmotionController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/26.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

private let emotionCellId = "emotionCellId"

class EmotionController: UIViewController {

    //MARK:- 回调属性
    var emotionCallBack : (_ emotion : Emotion) -> ()
    
    //MARK:控件属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewEmotionLayout())
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    
    //MARK:模型属性
    fileprivate lazy var emotionManager : EmotionManager = EmotionManager()
    
    init(emotionCallBack : @escaping(_ emotion : Emotion) -> ()) {
        self.emotionCallBack = emotionCallBack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }

}

extension EmotionController{
    fileprivate func setupUI(){
        self.view.addSubview(collectionView)
        self.view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.white
        toolBar.backgroundColor = UIColor.darkGray
        
        //手动布局
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar,"cView": collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        //准备Collection/TooBar
        preppareForCollectionView()
        prepareForToolBar()
        
    }
    
    fileprivate func preppareForCollectionView(){
        collectionView.register(EmotionViewCell.self, forCellWithReuseIdentifier: emotionCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func prepareForToolBar(){
        let titles = ["最近","默认","emoji","浪小花"]
        var items = [UIBarButtonItem]()
        var index = 0
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(toolBarItemClick(item:)))
            item.tag = index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
        toolBar.tintColor = UIColor.orange
        
    }
    
    @objc fileprivate func toolBarItemClick(item : UIBarButtonItem){
        Mylog("跳转到对应的 emoji 组中")
        let tag = item.tag
        
        let indexPath = NSIndexPath(item: 0, section: tag) as IndexPath
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension EmotionController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emotionManager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionManager.packages[section].emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emotionCellId, for: indexPath) as! EmotionViewCell
        cell.emotion = emotionManager.packages[indexPath.section].emotions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emotion = emotionManager.packages[indexPath.section].emotions[indexPath.item]
        Mylog(emotion)
        
        //插入最近
        insertToRecentEmotion(emotion)
        
        //回调给外界
        self.emotionCallBack(emotion)
    }
    /// 插入最近表情
    ///
    /// - Parameter emotion: 对应表情
    func insertToRecentEmotion(_ emotion : Emotion) {
        
        //空白和删除不能添加
        if emotion.isEmpty || emotion.isRemove {
            return
        }
        
        //如果之前有就删除 / 没有就添加
        if (emotionManager.packages.first?.emotions.contains(emotion))! {
            let index = emotionManager.packages.first?.emotions.index(of: emotion)
            emotionManager.packages.first?.emotions.remove(at: index!)
            
            //删除完插入到最开始
            emotionManager.packages.first?.emotions.insert(emotion, at: 0)
            return
        }else{
            emotionManager.packages.first?.emotions.insert(emotion, at: 0)
        }
        
        //移除最后一个或最近（第20个）
        emotionManager.packages.first?.emotions.remove(at: 19)
    }
}
//MARK : - 自定义UICollectionViewFlowLayout布局
class CollectionViewEmotionLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        //1.setupLayout
        let itemWH : CGFloat = UIScreen.main.bounds.size.width / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //2.setupScrollView
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let margin = (collectionView!.frame.size.height - 3*itemWH)/2
        let edgeInsets = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        collectionView?.contentInset = edgeInsets
        
    }
}
