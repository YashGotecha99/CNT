//
//  Documents.swift
//  TimeControllApp
//
//  Created by mukesh on 02/07/22.
//

import UIKit
import WebKit
class DocumentVC: BaseViewController {

    @IBOutlet weak var webVw: WKWebView!
    @IBOutlet weak var documenttblVw: UITableView!
    @IBOutlet weak var openWebView: UIView!
    
    var documentData : [DocumentRows]? = []
    
    var isLoadingList : Bool = false
    var isMoreDocument : Bool = true
    
    @IBOutlet weak var documentsTitleLbl: UILabel!
    
    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var notificationCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.makeSecure()
//        documentsTitleLbl.text = LocalizationKey.documents.localizing()
//        configUI()
      //  webVw.load(NSURLRequest(url: NSURL(string: "http://www.africau.edu/images/default/sample.pdf")! as URL) as URLRequest)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.makeSecure()
        documentsTitleLbl.text = LocalizationKey.documents.localizing()
        configUI()
    }
    
    func configUI() {
        
        notificationCountView.setNeedsLayout()
        notificationCountView.layer.cornerRadius = notificationCountView.frame.height/2
        notificationCountView.layer.masksToBounds = true
        
        
        openWebView.isHidden = true
        documenttblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.DocumentTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.DocumentTVC.rawValue)
        GlobleVariables.page = 0
        getDocumentListAPI()
    }
    
    @IBAction func crossBtnAction(_ sender: Any) {
        openWebView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension DocumentVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DocumentTVC.rawValue, for: indexPath) as? DocumentTVC
        else { return UITableViewCell() }
        
        guard let document = documentData?[indexPath.row] else { return UITableViewCell() }
        
        cell.setCellValue(document: document)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let document = documentData?[indexPath.row] else { return  }
        if document.status == nil  {
            let vc = STORYBOARD.DOCUMENTS.instantiateViewController(withIdentifier: "SignDocumentVC") as! SignDocumentVC
            vc.fromDocumentData = document
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            documentPreviewAPI(id: document.id ?? 0)
        }
    }
    
}

extension DocumentVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreDocument  ) {
            self.isLoadingList = true
            GlobleVariables.page = GlobleVariables.page + 1
            getDocumentListAPI()
        }
    }
}

//MARK: APi Work in View controller
extension DocumentVC {
    func getDocumentListAPI() {
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        print(param)
        DocumentVM.shared.documentListAPI(parameters: param, isAuthorization: true) { [self] obj in
            
            if obj.rows?.count ?? 0 > 0{
                self.isMoreDocument = true
            }else{
                self.isMoreDocument = false
            }
            for model in obj.rows ?? []{
                self.documentData?.append(model)
            }
            self.documenttblVw.reloadData()
        }
    }
    
    func documentPreviewAPI(id:Int) {
        var param = [String:Any]()
        DocumentVM.shared.documentPreviewAPI(parameters: param, id: id, isAuthorization: true){ [self] obj in
            if let path = obj.path {
                openWebView.isHidden = false
                let url: URL! = URL(string: path)
                webVw.load(URLRequest(url: url))
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
}

