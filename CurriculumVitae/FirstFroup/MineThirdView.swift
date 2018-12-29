//
//  MineThirdView.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/19.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit

class MineThirdView: BaseMineView {

    class func loadNib()-> UIView {
        let view:MineThirdView = Bundle.main.loadNibNamed("MineThirdView", owner: nil, options: nil)?.first as! MineThirdView
//        if UIDevice.current.isFullScreen() {
//            view.topCon!.constant = 88.0;
//        }
        
        return view
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
