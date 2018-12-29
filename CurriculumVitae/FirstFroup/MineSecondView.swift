//
//  MineSecondView.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/19.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit

class MineSecondView: BaseMineView {

    @IBOutlet var btnStart:UIButton?
    @IBOutlet var btnEnd:UIButton?

    class func loadNib()-> UIView {
        let view:MineSecondView = Bundle.main.loadNibNamed("MineSecondView", owner: nil, options: nil)?.first as! MineSecondView
//        if UIDevice.current.isFullScreen() {
//            view.topCon!.constant = 88.0;
//        }
        return view
    }
    override func addNormalModel(_ model: Person) {
        super.addNormalModel(model)

        let str:String = "-年-月-日"
        self.btnStart?.setTitle(str, for: .normal);
        self.btnStart?.setTitle(str, for: .selected);

        self.btnEnd?.setTitle(str, for: .normal);
        self.btnEnd?.setTitle(str, for: .selected);

        if ((self.normalModel?.schoolKey) != nil) {
            let schools:[School] = CoreDataManager.shared.getSchoolWith(name: (self.normalModel?.schoolKey)!)
            let school =  schools.first

            if ((school?.startTime) == nil) {
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            var msg = formatter.string(from: (school?.startTime)!)
            self.btnStart?.setTitle(msg, for: .normal);
            self.btnStart?.setTitle(msg, for: .selected);

            if ((school?.endTime) == nil) {
                return
            }
            msg = formatter.string(from: (school?.endTime)!)
            self.btnEnd?.setTitle(msg, for: .normal);
            self.btnEnd?.setTitle(msg, for: .selected);
        }else {

        }
    }
    @IBAction func btnClicked(sender:UIButton) {
        self.showDatePicker(NSDate.init(timeIntervalSince1970: 0), button: sender)

        if sender == btnStart {

        }else {
            
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    lazy var picker:UIDatePicker = {
        let picker = UIDatePicker.init(frame: CGRect.init(x: 0, y: 60, width: self.bounds.size.width, height: 130))
        picker.locale = Locale(identifier: Locale.current.identifier)
        picker.timeZone = TimeZone.current
        picker.datePickerMode = .date
        picker.date = Date.init(timeIntervalSinceNow: 100)
//        picker.setValue(UIColor.white, forKey: "textColor")
        picker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        return picker;
    }()
}
extension MineSecondView {
    private func showDatePicker(_ date:NSDate,button chooseBtn:UIButton) {
        let showVC:UIViewController = UIViewController.init()
        self.addSubview(showVC.view)

        let msg = String(format: "请选择您的%@日期\n\n\n\n\n\n\n", ((chooseBtn == btnStart) ? "入学" : "毕业"))
        let alertController = UIAlertController.init(title: "选择日期", message: msg, preferredStyle: .alert)
        self.picker.frame = CGRect.init(x: 0, y: 60, width: alertController.view.bounds.width-144.0, height:120)
        alertController.view.addSubview(self.picker)

        weak var weakSelf = self
        let cancelAction = UIAlertAction.init(title: "确定", style: .cancel) { (action) in
            print(action)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            let msg = formatter.string(from: (weakSelf?.picker.date)!)

            chooseBtn.setTitle(msg, for: .normal)
            chooseBtn.setTitle(msg, for: .selected)
            showVC.view.removeFromSuperview()

            if ((self.normalModel?.schoolKey) != nil) {
                let schools:[School] = CoreDataManager.shared.getSchoolWith(name: (self.normalModel?.schoolKey)!)
                let school =  schools.first

                if (chooseBtn == weakSelf?.btnStart) {
                    school?.startTime = weakSelf?.picker.date;
                }else {
                    school?.endTime = weakSelf?.picker.date;
                }
                CoreDataManager.shared.saveContext()
            }
        }

        alertController.addAction(cancelAction)
        showVC.present(alertController, animated: true, completion: nil)
    }

    @objc func dateChanged(datePicker:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
//        let msg = formatter.string(from: datePicker.date)
        DispatchQueue.main.async {
            print(formatter.string(from: datePicker.date))
        }
    }


}
