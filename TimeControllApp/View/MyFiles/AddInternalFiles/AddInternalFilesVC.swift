//
//  AddInternalFilesVC.swift
//  TimeControllApp
//
//  Created by mukesh on 11/07/22.
//

import UIKit

class AddInternalFilesVC: BaseViewController,UITextViewDelegate {

    @IBOutlet weak var desTxtVw: UITextView!
    @IBOutlet weak var addInternalFileTitleLbl: UILabel!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fileNameTxt: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        desTxtVw.delegate = self
        desTxtVw.text = "Type something here..."
        desTxtVw.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        addInternalFileTitleLbl.text = LocalizationKey.addInternalFile.localizing()
        fileNameLbl.text = LocalizationKey.fileName.localizing()
        fileNameTxt.placeholder = LocalizationKey.enterFileName.localizing()
        descriptionLbl.text = LocalizationKey.dESCRIPTION.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

}
