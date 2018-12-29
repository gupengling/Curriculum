//
//  BaseViewController.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/24.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit
@objc public protocol BaseViewControllerDataSource:NSObjectProtocol {
    @objc optional func readNavigationColor() -> UIColor
    @objc optional func readStatusColor() -> UIColor
}
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        self.initBaseTools()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.bgV.backgroundColor = self.readNavigationColor()//UIColor(red: 201/255.0, green: 115/255.0, blue: 228/255.0, alpha: 1.0)
        navigationController?.navigationBar.bgV.statusBarColor = self.readStatusColor()//UIColor(white: 0, alpha: 0.2)
//navigationController?.navigationBar.bgV.clear()
    }

    func initBaseTools() {
        if self.navigationController?.viewControllers.count != 0 {
            let btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
            btnBack.setImage(UIImage.init(named: "fanhui"), for: .normal)
            btnBack.setTitleColor(UIColor.blue, for: .normal)
            btnBack.addTarget(self, action: #selector(backClicked(_:)), for: .touchUpInside)
            btnBack.isEnabled = true
            //        var bar:UIBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "fanhui"), style: .done, target: self, action: nil)
            let btnBackView:UIView = UIView(frame: btnBack.bounds)
            btnBackView.addSubview(btnBack)
            let backBar = UIBarButtonItem(customView: btnBackView)
            self.navigationItem.leftBarButtonItem = backBar
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BaseViewController: BaseViewControllerDataSource {
    func readNavigationColor() -> UIColor {
        return UIColor.white
    }

    func readStatusColor() -> UIColor {
        return self.readNavigationColor()
    }

    @objc func backClicked(_ send:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
