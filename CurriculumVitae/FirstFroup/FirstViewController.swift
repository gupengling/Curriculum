//
//  FirstViewController.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/14.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit
import Foundation


let ScreenWidth  = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height


class FirstModel: NSObject {
    var type:CellViewtype?
    var pageIndex:NSInteger?
    var name:String?
    var normalData:Person?

    override init() {
        super.init()
    }

    required convenience init(map:[AnyHashable:Any]?) {
        self.init()
        self.mapping(map: map!)
    }

    private func mapping(map:[AnyHashable:Any]) {
        type = map["type"] as? CellViewtype
        pageIndex  = map["pageIndex"] as? NSInteger
        name  = map["name"] as? String
    }
}

class FirstViewController: BaseViewController {

    let Identifier       = "CollectionViewCell"
//    let headerIdentifier = "CollectionHeaderView"
//    let footIdentifier   = "CollectionFootView"
    @IBOutlet var conView:UICollectionView!
    @IBOutlet weak var labTitle:UILabel!
    private var keyBoardWrapper :GPLKeyBoardWrapper?
    private var index:NSIndexPath?


    private var btnNext:UIButton!

    deinit {
        //        keyBoardWrapper = nil
        //        conView = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTools()


        self.requestData { [weak self] (result) in
            if result {
                self!.btnNext.isEnabled = true
                self!.index = NSIndexPath(item: 0, section: 0)

                self!.labTitle.text = NSString(format: "1/%d",self!.arrData.count) as String
                self!.conView.reloadData()
            }else {
                print("error")
            }
        }
    }

    func initTools (){
        extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            self.conView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        labTitle.text = ""
        keyBoardWrapper = GPLKeyBoardWrapper.init(delegate: self as GPLKeyBoardWrapperDelegate)


        let btnDone = UIButton(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
//        btnDone.setTitle("下一步", for: .normal)
        btnDone.setImage(UIImage.init(named: "next"), for: .normal)
        btnDone.setTitleColor(UIColor.blue, for: .normal)
        btnDone.addTarget(self, action: #selector(saveItemClicked(_:)), for: .touchUpInside)
        btnDone.isEnabled = false
        self.btnNext = btnDone
        let btnView:UIView = UIView(frame: btnDone.bounds)
        btnView.addSubview(btnDone)
        let saveBar = UIBarButtonItem(customView: btnView)
//        let rightBar = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(saveItemClicked(_:)))
        self.navigationItem.rightBarButtonItem = saveBar


        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        let statusbarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
        //        let navHeight = self.navigationController!.navigationBar.frame.size.height

        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
        //        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 0;//设置最小行间距
        layout.minimumInteritemSpacing = 0;//设置同一列中间隔的cell最小间距
        layout.scrollDirection = .horizontal;
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        // 设置分区头视图和尾视图宽高
        //        layout.headerReferenceSize = CGSize.init(width: ScreenWidth, height: 80)
        //        layout.footerReferenceSize = CGSize.init(width: ScreenWidth, height: 80)
        conView.collectionViewLayout = layout;
        conView.isPagingEnabled = true;

        // 注册cell
        conView?.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier)
        //        // 注册headerView
        //        conView?.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        //        // 注册footView
        //        conView?.register(CollectionFooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footIdentifier)
        conView.backgroundColor = UIColor.red

        // Do any additional setup after loading the view.

        conView.delegate = self;
        conView.dataSource = self;
    }

    //请求数据
    func requestData(completeation:@escaping (_ result:Bool)->())->() {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            let arrType = [CellViewtype.MineInfo,CellViewtype.MineSecond,CellViewtype.MineThird]
            for i in 0 ..< (arrType.count) {
                let model:FirstModel = FirstModel(map: ["type":arrType[i],"pageIndex":i]);
                model.normalData = self.normalModel
                self.arrData.append(model)
            }
            completeation(true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func armColor()->UIColor{
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    //MARK: lazy方法
    lazy var arrData:[FirstModel] = {
        let arrData = [FirstModel].init()
        return arrData;
    }()

    lazy var normalModel:Person = {
        var model = Person()
//        model.name = "wodetian"
        let arr:[Person] = CoreDataManager.shared.getAllPerson()

        if arr.count > 0 {
            model = arr[0]
        }
        return model
    }()

}
extension FirstViewController {
    override func readNavigationColor() -> UIColor {
        return UIColor.clear//UIColor(red: 201/255.0, green: 115/255.0, blue: 228/255.0, alpha: 1.0)
    }
//    override func readStatusColor() -> UIColor {
//        return UIColor.red
//    }
    @objc func saveItemClicked(_ send:UIButton) {
        if index?.item == arrData.count-1 {
            print("save")
        }else {
            print("next")
            conView.scrollToItem(at: NSIndexPath(item: (index?.item)!+1, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension FirstViewController:GPLKeyBoardWrapperDelegate {
    func keyBoardWrapper(_ wrapper: GPLKeyBoardWrapper, didChangeKeyboardInfo info: GPLKeyBoardInfo) {
//        print("info ",info.notification.userInfo?.description as Any ,"\n",info.state,"\n")
        switch info.state {
        case .willChangeFrame:
            print("willChangeFrame",info.beginFrame,info.endFrame)
        case .didChangeFrame:
            print("didChangeFrame",info.beginFrame,info.endFrame)
        case .willHide:
            print("willHide",info.beginFrame,info.endFrame)
        case .didHidden:
            print("didHidden",info.beginFrame,info.endFrame)
        case .willShow:
            print("willShow",info.beginFrame,info.endFrame)
        case .didShow:
            print("didShow",info.beginFrame,info.endFrame)
        }
//        UIView.animate(withDuration: info.animationDuration) {
//            print("end!!!!")
//        }
    }
}

extension FirstViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! CollectionViewCell
        //        cell.frame = self.view.bounds//CGRect.init(x: cell.frame.origin.x, y: cell.frame.origin.y, width: self.view.bounds.width, height: self.view.bounds.height)
        cell.backgroundColor = armColor()
        cell.showViewWithModel(self.arrData[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select %d",indexPath.item)
        self.view.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page:Int = Int((scrollView.contentOffset.x/ScreenWidth)+1.0)

        index = NSIndexPath(item: page-1, section: 0)

        self.btnNext.isEnabled = true
        if page == arrData.count {
//            btn.setTitle("保存", for: .normal)
            self.btnNext.setImage(UIImage.init(named: "done"), for: .normal)
        }else {
//            btn.setTitle("下一步", for: .normal)
            self.btnNext.setImage(UIImage.init(named: "next"), for: .normal)
        }

        labTitle.text = NSString(format: "%d/%d", page,self.arrData.count) as String
    }

//    //header高度
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize.init(width: ScreenWidth, height: 80)
//    }
//    //footer高度
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize.init(width: ScreenWidth, height: 80)
//    }

//设定header和footer的方法，根据kind不同进行不同的判断即可
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader{
//            let headerView : CollectionHeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! CollectionHeaderReusableView
//            headerView.backgroundColor = UIColor.red
////            headerView.label.text = "This is HeaderView"
//            return headerView
//        }else{
//            let footView : CollectionFooterReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footIdentifier, for: indexPath) as! CollectionFooterReusableView
//            footView.backgroundColor = UIColor.purple
////            footView.label.text = "This is Foot"
//            return footView
//        }
//    }
}
