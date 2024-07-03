//
//  SelectFunctionVC.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 28/11/22.
//

import UIKit

class SelectFunctionVC: BaseViewController {

    @IBOutlet var vwContainer: UIView!
    
    var callback : ((Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwContainer.addGestureRecognizer(tap)
       
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        self.dismiss(animated: true)
    }
   

    @IBAction func btnTaskMapAction(_ sender: UIButton) {
        self.dismiss(animated: true)
     //   self.navigationController?.dismiss(animated: true, completion: {
//            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectTasksVC") as! SelectTasksVC
//            self.navigationController?.pushViewController(vc, animated: true)
      //  })
        callback?(true)
       
    }
    
    @IBAction func btnRegisterManually(_ sender: UIButton) {
    }
    
}
