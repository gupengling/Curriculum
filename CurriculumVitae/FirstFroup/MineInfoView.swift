//
//  MineInfoView.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/17.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit

class MineInfoView: BaseMineView {
    @IBOutlet var btnMan:UIButton!
    @IBOutlet var btnWoman:UIButton!
    
    class func loadNib()-> UIView {
        let view:MineInfoView = Bundle.main.loadNibNamed("MineInfoView", owner: nil, options: nil)?.first as! MineInfoView
//        if UIDevice.current.isFullScreen() {
//            view.topCon!.constant = 88.0;
//        }
        return view
    }
    override func addNormalModel(_ model: Person) {
        super.addNormalModel(model)

        if (self.btnMan != nil) {
            self.btnMan.isSelected = model.sex
            self.btnWoman.isSelected = !model.sex
        }
    }

    @IBAction func btnClicked(sender:UIButton) {
        let sex = (sender == btnMan)
        btnMan.isSelected = sex
        btnWoman.isSelected = !sex
        self.normalModel?.sex = sex
        CoreDataManager.shared.saveContext()
//        CoreDataManager.shared.changePersonWith(name: self.normalModel?.name ?? "", newName: self.normalModel?.name ?? "", newAge: 20)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

