//
//  SignDocumentVC.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 05/06/23.
//

import UIKit
import WebKit

class SignDocumentVC: BaseViewController {
    
    @IBOutlet weak var documentTitleLbl: UILabel!
    @IBOutlet weak var staticIhaveReadThis: UILabel!
    @IBOutlet weak var staticSignature: UILabel!
    @IBOutlet weak var iHaveReadBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var readLaterBtn: UIButton!
    
    @IBOutlet weak var uploadSignatureBgImg: UIImageView!
    @IBOutlet weak var uploadSignatureImg: UIImageView!
    @IBOutlet weak var changeSignatureView: UIView!
    @IBOutlet weak var mainContantView: UIView!
    
    var isReaded = false
    var signatureImg: UIImage?

    @IBOutlet weak var signatureWebVw: WKWebView!
    var fromDocumentData : DocumentRows?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("fromDocumentData is : ", fromDocumentData)
        mainContantView.makeSecure()
        documentTitleLbl.text = LocalizationKey.documents.localizing()
        staticSignature.text = LocalizationKey.signature.localizing()
        confirmBtn.setTitle(LocalizationKey.confirm.localizing(), for: .normal)
        readLaterBtn.setTitle(LocalizationKey.readLater.localizing(), for: .normal)
        staticIhaveReadThis.text = LocalizationKey.iHaveReadThisDocument.localizing()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        documentPreviewAPI(id: fromDocumentData?.id ?? 0)
    }
    
    @IBAction func addSignatureBtn(_ sender: Any) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeSignatureBtn(_ sender: Any) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func iHaveReadBtn(_ sender: Any) {
        if isReaded {
            isReaded = false
            iHaveReadBtn.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isReaded = true
            iHaveReadBtn.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
    }

    @IBAction func confirmBtnActions(_ sender: Any) {
        if !isReaded {
            showAlert(message: "Please click the read document", strtitle: LocalizationKey.alert.localizing())
            return
        }
        if (fromDocumentData?.is_signature_required ?? false && signatureImg == nil) {
            showAlert(message: "Please sign the document", strtitle: LocalizationKey.alert.localizing())
            return
        }
        confirmTheDocument()
    }
    
    @IBAction func readLaterBtnActions(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SignDocumentVC : SignatureProtocol {
    func signatureImg(signatureImage: UIImage) {
        signatureImg = signatureImage
        uploadSignatureBgImg.image = signatureImage
        uploadSignatureBgImg.contentMode = .scaleAspectFit
        uploadSignatureBgImg.layer.borderWidth = 0.5
        
        changeSignatureView.isHidden = false
        uploadSignatureImg.isHidden = true
    }
}

//MARK: APi Work in View controller
extension SignDocumentVC {
    func documentPreviewAPI(id:Int) {
        var param = [String:Any]()
        DocumentVM.shared.documentPreviewAPI(parameters: param, id: id, isAuthorization: true){ [self] obj in
            if let path = obj.path {
                let url: URL! = URL(string: path)
                signatureWebVw.load(URLRequest(url: url))
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
    func confirmTheDocument() {
        var param = [String:Any]()
        param["document_id"] = fromDocumentData?.id
        param["status"] = "read"
        param["signature"] = (signatureImg != nil) ? "data:image/png;base64," + (self.convertImageToBase64String(img: signatureImg ?? UIImage()) ?? "") : ""
        DocumentVM.shared.confirmDocument(parameters: param){ [self] obj in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
