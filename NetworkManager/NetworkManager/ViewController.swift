//
//  ViewController.swift
//  NetworkManager
//
//  Created by Liudongdong on 2019/7/1.
//  Copyright © 2019 文刂Rn. All rights reserved.
//

import UIKit
import RxNetwork
import NSObject_Rx

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        GameApi
            .gameHomePage(1, .hot)
            .request().map(GameInfo.self)
            .onCache([GameInfo].self, atKeyPath: "result", { (list) in
                print("list=======\(list.count)")
            })
            .request()
//            .mapObject([GameInfo].self)
            .subscribe(onSuccess: { (list) in
                print("list=======\(list.count)")
            }) { (error) in
                print("error=======\(error)")
            }.disposed(by: rx.disposeBag)
        
    }
    
}

