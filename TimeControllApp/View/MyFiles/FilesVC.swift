//
//  FilesVC.swift
//  TimeControllApp
//
//  Created by mukesh on 02/07/22.
//

import UIKit

class FilesVC: BaseViewController {

    @IBOutlet weak var filesSegmentController: UISegmentedControl!
    @IBOutlet weak var filetblView: UITableView!
    
    @IBOutlet weak var btnObjAdd: UIButton!
    @IBOutlet weak var comingSoonLbl: UILabel!
    @IBOutlet weak var searchFilesTxt: UITextField!
    @IBOutlet weak var myFilesTItleLbl: UILabel!
    
    var isLoadingList : Bool = false
    var arrMyFilesData : [MyFilesRows]? = []
    private var segmentControlIndex = 0
    var isMoreFilesData : Bool = false
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var personalInfoVw: UIView!
    @IBOutlet weak var staticPersonalInfoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpLocalization()
//        configUI()
    }
    
    func configUI() {
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        filesSegmentController.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        filesSegmentController.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        filetblView.register(UINib.init(nibName: TABLE_VIEW_CELL.MyFilesTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.MyFilesTVC.rawValue)
        
        filesSegmentController.addTarget(self, action: "segmentedMyFilesControlValueChanged:", for: UIControl.Event.valueChanged)

        self.arrMyFilesData = []
        segmentControlIndex = 0
        filetblView.reloadData()
        GlobleVariables.page = 0
        btnObjAdd.isHidden = true
        personalInfoVw.isHidden = false
        searchVw.isHidden = true
        filetblView.isHidden = true
        
        personalInfoVw.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        personalInfoVw.layer.shadowOpacity = 0.5
        personalInfoVw.layer.shadowOffset = .zero
        personalInfoVw.layer.shadowRadius = 6

//        getMyFilesAPI(userId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
//        filetblView.reloadData()
    }
    func setUpLocalization(){
        myFilesTItleLbl.text = LocalizationKey.myFiles.localizing()
        searchFilesTxt.placeholder = LocalizationKey.search.localizing()
        
        filesSegmentController.setTitle(LocalizationKey.files.localizing(), forSegmentAt: 0)
        filesSegmentController.setTitle(LocalizationKey.contracts.localizing(), forSegmentAt: 1)
        filesSegmentController.setTitle(LocalizationKey.internalDOC.localizing(), forSegmentAt: 2)
        comingSoonLbl.text = LocalizationKey.comingSoon.localizing()
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.textFieldShouldReturn(searchFilesTxt)
    }
    
    @IBAction func personalInfoBtnAction(_ sender: Any) {
        let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddFilesVC") as! AddFilesVC
        vc.selectedFilesSegmmentIndex = segmentControlIndex
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func addBtnAction(_ sender: Any) {
//        if filesSegmentController.selectedSegmentIndex == 0 {
//            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddFilesVC") as! AddFilesVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else if filesSegmentController.selectedSegmentIndex == 1{
//            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddContactsVC") as! AddContactsVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else if filesSegmentController.selectedSegmentIndex == 2{
//            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddInternalFilesVC") as! AddInternalFilesVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        if segmentControlIndex == 0 {
            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddFilesVC") as! AddFilesVC
            vc.selectedFilesSegmmentIndex = segmentControlIndex
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else if segmentControlIndex == 1 {
            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddContactsVC") as! AddContactsVC
            vc.comingFrom = "Add"
            vc.selectedFilesSegmmentIndex = segmentControlIndex
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddContactsVC") as! AddContactsVC
            vc.comingFrom = "Add"
            vc.selectedFilesSegmmentIndex = segmentControlIndex
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func segmentedMyFilesControlValueChanged(_ sender: UISegmentedControl) {
        segmentControlIndex = sender.selectedSegmentIndex
        GlobleVariables.page = 0
        self.searchFilesTxt.text = ""
        self.arrMyFilesData = []
        filetblView.reloadData()
        if sender.selectedSegmentIndex == 0 {
            personalInfoVw.isHidden = false
            searchVw.isHidden = true
            filetblView.isHidden = true
            btnObjAdd.isHidden = true
//            getMyFilesAPI(userId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
        } else if sender.selectedSegmentIndex == 1 {
            personalInfoVw.isHidden = true
            searchVw.isHidden = false
            filetblView.isHidden = false
            btnObjAdd.isHidden = false
            getMyContractsAPI()
        } else {
            personalInfoVw.isHidden = true
            searchVw.isHidden = false
            filetblView.isHidden = false
            btnObjAdd.isHidden = false
            getMyInternalDocAPI()
        }
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension FilesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyFilesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MyFilesTVC.rawValue, for: indexPath) as? MyFilesTVC
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.lblName.text = arrMyFilesData?[indexPath.row].name
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.clickToDeleteBtn), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        if segmentControlIndex == 0 {
            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddFilesVC") as! AddFilesVC
            vc.selectedFilesSegmmentIndex = segmentControlIndex
            vc.filesID = arrMyFilesData?[indexPath.row].id ?? 0
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else */
        if segmentControlIndex == 1 {
            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddContactsVC") as! AddContactsVC
            vc.comingFrom = "Details"
            vc.selectedFilesSegmmentIndex = segmentControlIndex
            vc.contractID = arrMyFilesData?[indexPath.row].id ?? 0
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = STORYBOARD.FILES.instantiateViewController(withIdentifier: "AddContactsVC") as! AddContactsVC
            vc.comingFrom = "Details"
            vc.selectedFilesSegmmentIndex = segmentControlIndex
            vc.contractID = arrMyFilesData?[indexPath.row].id ?? 0
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (arrMyFilesData?.count ?? 0) - 1 && isMoreFilesData {
            GlobleVariables.page = GlobleVariables.page + 1
            if segmentControlIndex == 0 {
                getMyFilesAPI(userId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
            } else if segmentControlIndex == 1 {
                getMyContractsAPI()
            } else {
                getMyInternalDocAPI()
            }
        }
    }
    
    @objc func clickToDeleteBtn(_ sender: UIButton) {
        let index = sender.tag
        let alert = UIAlertController(title: "", message: LocalizationKey.areYouSureToDeleteThis.localizing(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            if self.segmentControlIndex == 0 {
                self.hitDeleteMyFiles(index: index)
            } else {
                self.hitDeleteMyContractOrInternalDoc(index: index)
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FilesVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        GlobleVariables.page = 0
        if segmentControlIndex == 0 {
            getMyFilesAPI(searchName: textField.text ?? "", userId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", withSearch: true)
        } else if segmentControlIndex == 1 {
            getMyContractsAPI(searchName: textField.text ?? "", withSearch: true)
        } else {
            getMyInternalDocAPI(searchName: textField.text ?? "", withSearch: true)
        }
        return true
    }
}

extension FilesVC:AddFilesVCDelegate {
    func checkFilesSegmentIndex(segmentIndex: Int) {
        self.arrMyFilesData?.removeAll()
        filetblView.reloadData()
        GlobleVariables.page = 0
        if segmentIndex == 0 {
            personalInfoVw.isHidden = false
            searchVw.isHidden = true
            filetblView.isHidden = true
            btnObjAdd.isHidden = true
//            getMyFilesAPI(userId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
        } else if segmentIndex == 1 {
            personalInfoVw.isHidden = true
            searchVw.isHidden = false
            filetblView.isHidden = false
            btnObjAdd.isHidden = false
            getMyContractsAPI()
        } else {
            personalInfoVw.isHidden = true
            searchVw.isHidden = false
            filetblView.isHidden = false
            btnObjAdd.isHidden = false
            getMyInternalDocAPI()
        }
    }
}

//MARK: Extension Api's
extension FilesVC {
    func getMyFilesAPI(searchName name:String = "", userId: String = "",withSearch isSearch: Bool = false) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"mode\":\"attachments\",\"name\":\"\(name)\"}"

        print(param)

        if isSearch {
            self.arrMyFilesData?.removeAll()
            GlobleVariables.page = 0
        }
        
        MyFilesVM.shared.getMyFilesData(parameters: param, isAuthorization: true, userId: userId) { [self] obj in
            self
//            arrMyFilesData = obj.rows
            if obj.rows?.count ?? 0 > 0{
                self.isMoreFilesData = true
            }else{
                self.isMoreFilesData = false
            }
            for model in obj.rows ?? []{
                self.arrMyFilesData?.append(model)
            }
            self.filetblView.reloadData()
        }
    }
    
    func getMyContractsAPI(searchName name:String = "",withSearch isSearch: Bool = false) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"mode\":\"contracts\",\"name\":\"\(name)\"}"
        print(param)

        if isSearch {
            self.arrMyFilesData?.removeAll()
            GlobleVariables.page = 0
        }
        
        MyFilesVM.shared.getMyContractData(parameters: param, isAuthorization: true) { [self] obj in
            self
//            arrMyFilesData = obj.rows
            if obj.rows?.count ?? 0 > 0{
                self.isMoreFilesData = true
            }else{
                self.isMoreFilesData = false
            }
            for model in obj.rows ?? []{
                self.arrMyFilesData?.append(model)
            }
            self.filetblView.reloadData()
        }
    }
    
    func getMyInternalDocAPI(searchName name:String = "",withSearch isSearch: Bool = false) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"mode\":\"internal\",\"name\":\"\(name)\"}"
        print(param)

        if isSearch {
            self.arrMyFilesData?.removeAll()
            GlobleVariables.page = 0
        }
        
        MyFilesVM.shared.getMyContractData(parameters: param, isAuthorization: true) { [self] obj in
            self
//            arrMyFilesData = obj.rows
            if obj.rows?.count ?? 0 > 0{
                self.isMoreFilesData = true
            }else{
                self.isMoreFilesData = false
            }
            for model in obj.rows ?? []{
                self.arrMyFilesData?.append(model)
            }
            self.filetblView.reloadData()
        }
    }
    
    func hitDeleteMyFiles(index:Int) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        
        MyFilesVM.shared.deleteMyFiles(fileId: arrMyFilesData?[index].id ?? 0){ [self] obj in
            getMyFilesAPI(userId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
        }
    }
    
    func hitDeleteMyContractOrInternalDoc(index:Int) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        
        MyFilesVM.shared.deleteContractsOrInternalDoc(fileId: arrMyFilesData?[index].id ?? 0){ [self] obj in
            arrMyFilesData?.remove(at: index)
            filetblView.reloadData()
//            if segmentControlIndex == 1 {
//                getMyContractsAPI()
//            } else {
//                getMyInternalDocAPI()
//            }
        }
    }
    
}
