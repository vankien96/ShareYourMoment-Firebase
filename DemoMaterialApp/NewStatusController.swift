//
//  NewStatusController.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/4/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit

class NewStatusController: UIViewController {

    @IBOutlet var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        btnBack.setImage(UIImage(named: "icon_backspace")?.tint(with: UIColor.white), for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func clickOnButtonback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
