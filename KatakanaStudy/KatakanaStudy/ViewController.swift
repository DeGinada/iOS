//
//  ViewController.swift
//  KatakanaStudy
//
//  Created by Sora Yeo on 2017. 7. 9..
//  Copyright © 2017년 DeGi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let naviBar = navigationController!.navigationBar
        
        naviBar.backgroundColor = UIColor.white
        naviBar.tintColor = UIColor.darkGray
        naviBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        naviBar.shadowImage = UIImage()
        naviBar.barTintColor = UIColor.white
        naviBar.topItem?.title = ""
        
    }


}

