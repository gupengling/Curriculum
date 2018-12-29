//
//  BaseMineView.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/20.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit
class BaseMineView: UIView {

    var normalModel: Person?

    @IBOutlet weak var txfName:UITextField?
    @IBOutlet weak var txfSchool:UITextField?
    @IBOutlet weak var txfMyOverSchool:UITextField?
    @IBOutlet weak var txfLoveJob:UITextField?
    @IBOutlet weak var topCon: NSLayoutConstraint?


    public func addNormalModel(_ model:Person) {
        self.normalModel = model
        if ((self.normalModel?.name) != nil) {
            self.txfName?.text = self.normalModel?.name
        }
        if ((self.normalModel?.schoolKey) != nil) {
            let schools:[School] = CoreDataManager.shared.getSchoolWith(name: (self.normalModel?.schoolKey)!)
            let school =  schools.first
            self.txfSchool?.text = school!.name
        }
        self.txfMyOverSchool?.text = self.normalModel?.education
        if self.normalModel?.industry?.count ?? 0 > 0 {
            self.txfLoveJob?.text = (self.normalModel?.industry![0] as! String)
        }


        self.txfName?.delegate = self
        self.txfSchool?.delegate = self
        self.txfMyOverSchool?.delegate = self
        self.txfLoveJob?.delegate = self

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension BaseMineView:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txfName:
            self.normalModel?.name = textField.text
        case self.txfSchool:
            if ((self.normalModel?.schoolKey) != nil) {
                let schools:[School] = CoreDataManager.shared.getSchoolWith(name: (self.normalModel?.schoolKey)!)
                let school =  schools.first
                school!.name = textField.text
            }else {
                self.normalModel?.schoolKey = self.normalModel?.name
                CoreDataManager.shared.saveSchoolWith(key: (self.normalModel?.schoolKey)!, name: textField.text ?? "")
            }
        case self.txfMyOverSchool:
            self.normalModel?.education = textField.text
        case self.txfLoveJob:
            if self.normalModel?.industry?.count ?? 0 > 0 {
                self.normalModel?.industry?.replaceObject(at: 0, with: textField.text! as NSString)
            }else {
                let arr:NSMutableArray = NSMutableArray()
                arr.insert(textField.text! as NSString, at: 0)
                self.normalModel?.industry = arr
            }
        default:
            break
        }
        CoreDataManager.shared.saveContext()

    }
}
