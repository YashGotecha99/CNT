//
//  SignatureVC.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 17/11/22.
//

import UIKit
import SignaturePad

protocol SignatureProtocol {
    
    func signatureImg(signatureImage: UIImage)
}


class SignatureVC: UIViewController,SignaturePadDelegate {
    
    @IBOutlet weak var vwSignature: SignaturePad!
    
    var delegate: SignatureProtocol?
    
    //MARK: Localizations

    @IBOutlet weak var clearBtnObj: UIButton!
    @IBOutlet weak var staticSignatureLbl: UILabel!
    @IBOutlet weak var applyBtnObj: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        vwSignature.clear()

        self.vwSignature.delegate = self
      
    }
    
    func setUpLocalization(){
        staticSignatureLbl.text  = LocalizationKey.signature.localizing()
        clearBtnObj.setTitle(LocalizationKey.clear.localizing(), for: .normal)
        applyBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    
    
    func didStart() {
        print("start")
    }
    
    func didFinish() {
        print("Finish")
    }
    
   
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClearAction(_ sender: UIButton) {
        
       vwSignature.clear()
     

    }
    
    @IBAction func btnApplyAction(_ sender: UIButton) {
        if vwSignature.isSigned {
            if let signature = vwSignature.getSignature() {
                
                print(signature)
               // print(convertImageToBase64String(img: signature))
                delegate?.signatureImg(signatureImage: signature)
                
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            showAlert(message: LocalizationKey.pleaseEnterSignature.localizing(), strtitle: LocalizationKey.error.localizing()) {_ in
            }
        }
    }

}
