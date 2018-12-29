//
//  ViewController.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/14.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if CoreDataManager.shared.getAllPerson().count == 0 {
            CoreDataManager.shared.savePersonWith(name: "xiaoming", age: 23)
        }
        print("test")
//        CoreDataManager.shared.savePersonWith(name: "xiaozhang", age: 22)
//        let data:[Person] = CoreDataManager.shared.getAllPerson()
//        for p:Person in data {
//            print(p.name! + "\(p.age)")
//        }
//        print(data.count)
//
//        CoreDataManager.shared.deleteWith(name: "xiaoming")
//        let data1:[Person] = CoreDataManager.shared.getAllPerson()
//        for p:Person in data1 {
//            print(p.name! + "\(p.age)")
//        }
//        print(data1.count)
//
//        CoreDataManager.shared.deleteAllPerson()
//        let data2:[Person] = CoreDataManager.shared.getAllPerson()
//        for p:Person in data2 {
//            print(p.name! + "\(p.age)")
//        }
//        print(data2.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func firstBtnClicked(_ sender: Any) {
        let firstVC:FirstViewController = FirstViewController(nibName: "FirstViewController", bundle: Bundle.main);
        self.navigationController?.pushViewController(firstVC, animated: true);

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.bgV.backgroundColor = UIColor(red: 255/255.0, green: 115/255.0, blue: 228/255.0, alpha: 1.0)
        navigationController?.navigationBar.bgV.statusBarColor = UIColor(white: 0, alpha: 0.0)
    }

    
}

