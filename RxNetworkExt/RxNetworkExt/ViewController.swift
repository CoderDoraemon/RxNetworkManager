//
//  ViewController.swift
//  RxNetworkExt
//
//  Created by LDD on 2019/6/30.
//  Copyright © 2019 LDD. All rights reserved.
//

import UIKit
import NSObject_Rx

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameApi.gameHomePage(1, .hot)
            .request()
            .mapObject([GameInfo].self)
            .subscribe(onSuccess: { (list) in
                print("list=======\(list)")
            }) { (error) in
                print("error=======\(error)")
            }
            .disposed(by: rx.disposeBag)
    }
    
}

