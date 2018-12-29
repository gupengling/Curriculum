//
//  CollectionViewCell.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/14.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit


enum CellViewtype {
    case MineInfo
    case MineSecond
    case MineThird
}

class CollectionViewCell: UICollectionViewCell {
    var cellModel:FirstModel? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    public func showViewWithModel(_ model:FirstModel) {
        cellModel = model;
        var view:BaseMineView! = nil

        switch cellModel?.type {
        case .MineInfo?:
            view = MineInfoView.loadNib() as? BaseMineView
//            (view as! MineInfoView).addNormalModel(model.normalData!)
//            let view:MineInfoView = Bundle.main.loadNibNamed("MineInfoView", owner: nil, options: nil)?.first as! MineInfoView
//            view.frame = self.bounds;
//            self.addSubview(view)
        case .MineSecond?:
            view = MineSecondView.loadNib()as? BaseMineView
        case .MineThird?:
            view = MineThirdView.loadNib()as? BaseMineView
        default: break

        }
        view.addNormalModel(model.normalData!)
        if (view != nil) {
            view?.frame = self.bounds;
            self.addSubview(view ?? UIView())
        }

    }
}

