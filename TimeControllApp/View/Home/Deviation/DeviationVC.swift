//
//  DeviationVC.swift
//  TimeControllApp
//
//  Created by mukesh on 17/07/22.
//

import UIKit
import SVProgressHUD

enum DeviationType:String {
    case New = "new,assigned"
    case UnderWork = "working"
    case Done = "complete,approved"
}

class DeviationVC: BaseViewController {

    @IBOutlet weak var deviationTitleLbl: UILabel!
    @IBOutlet weak var deviationStatusSegmentControl: UISegmentedControl!
    @IBOutlet weak var deviationlisttblVw: UITableView!
    
    private var segmentControlIndex = 0
    
    var isMoreData : Bool = true
    var isLoadingList : Bool = false

    var arrDeviationsData : [DeviationsList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }

    func setUpLocalization() {
        deviationTitleLbl.text = LocalizationKey.deviations.localizing()
        deviationStatusSegmentControl.setTitle(LocalizationKey.new.localizing(), forSegmentAt: 0)
        deviationStatusSegmentControl.setTitle(LocalizationKey.underWork.localizing(), forSegmentAt: 1)
        deviationStatusSegmentControl.setTitle(LocalizationKey.done.localizing(), forSegmentAt: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func configUI() {
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        deviationStatusSegmentControl.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        deviationStatusSegmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        deviationStatusSegmentControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        deviationlisttblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.DeviationTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.DeviationTVC.rawValue)
        
        GlobleVariables.page = 0
        self.arrDeviationsData = []
        getDeviation(status: DeviationType.New.rawValue)
        
        deviationlisttblVw.reloadData()
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        segmentControlIndex = sender.selectedSegmentIndex
        deviationlisttblVw.reloadData()
        GlobleVariables.page = 0
        self.arrDeviationsData = []
        if sender.selectedSegmentIndex == 0 {
            deviationStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            getDeviation(status: DeviationType.New.rawValue)
        } else if sender.selectedSegmentIndex == 1 {
            deviationStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            getDeviation(status: DeviationType.UnderWork.rawValue)
        } else {
            deviationStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            getDeviation(status: DeviationType.Done.rawValue)
        }
    }
    
    @IBAction func createDeviaitionBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CreateDeviationVC") as! CreateDeviationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DeviationVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreData  ) {
            self.isLoadingList = true
            GlobleVariables.page = GlobleVariables.page + 1
            
            if segmentControlIndex == 0 {
                getDeviation(status: DeviationType.New.rawValue)
            }
            else if segmentControlIndex == 1 {
                getDeviation(status: DeviationType.UnderWork.rawValue)
            }
            else {
                getDeviation(status: DeviationType.Done.rawValue)
            }
        }
    }
    
    func showActionSheet(segmentIndex:Int, deviationID: Int, indexPathId: IndexPath) {
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm" {
            
            let alert = UIAlertController(title: "", message: LocalizationKey.action.localizing(), preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: LocalizationKey.viewDetails.localizing(), style: .default , handler:{ (UIAlertAction)in
                
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationDetailVC") as! DeviationDetailVC
                vc.selectedSegmmentIndex = segmentIndex
                vc.delegate = self
                vc.selectedDeviationsID = deviationID
                self.navigationController?.pushViewController(vc, animated: true)

            }))
            
            alert.addAction(UIAlertAction(title: LocalizationKey.delete.localizing(), style: .destructive , handler:{ (UIAlertAction)in
                self.showAlert(title: LocalizationKey.alert.localizing(), message: LocalizationKey.areYouSureToDeleteThis.localizing(), status: "delete", id: deviationID, indePathId: indexPathId)
            }))
            
            alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        } else {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationDetailVC") as! DeviationDetailVC
            vc.selectedSegmmentIndex = segmentIndex
            vc.delegate = self
            vc.selectedDeviationsID = deviationID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: Show Alert
    
    func showAlert(title: String, message: String, status: String, id: Int, indePathId : IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.deleteDeviationAPI(id: id, indePathId: indePathId)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension DeviationVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 0
        if deviationStatusSegmentControl.selectedSegmentIndex == 0 {
            count = self.arrDeviationsData.count
        } else if deviationStatusSegmentControl.selectedSegmentIndex == 1 {
            count = self.arrDeviationsData.count
        } else {
            count = self.arrDeviationsData.count
        }
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noDeviationAvailable.localizing()
            noDataLabel.textColor     = Constant.appColor
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
        }else{
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDeviationsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationTVC.rawValue, for: indexPath) as? DeviationTVC
        else { return UITableViewCell() }
        cell.configUI(index: segmentControlIndex)
        cell.selectionStyle = .none
        if (arrDeviationsData.count > 0) {
            cell.setData(deviationsData: (arrDeviationsData[indexPath.row]))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationDetailVC") as! DeviationDetailVC
//        vc.selectedSegmmentIndex = segmentControlIndex
//        vc.delegate = self
//        vc.selectedDeviationsID = arrDeviationsData[indexPath.row].id ?? 0
//        self.navigationController?.pushViewController(vc, animated: true)
        
        showActionSheet(segmentIndex: segmentControlIndex, deviationID: arrDeviationsData[indexPath.row].id ?? 0, indexPathId: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension DeviationVC:DeviationVCDelegate {
    func checkSegmentIndex(segmentIndex: Int) {
        GlobleVariables.page = 0
        self.arrDeviationsData.removeAll()
        deviationlisttblVw.reloadData()
        if segmentIndex == 0 {
            getDeviation(status: DeviationType.New.rawValue)
        }
        else if segmentIndex == 1 {
            getDeviation(status: DeviationType.UnderWork.rawValue)
        }
        else {
            getDeviation(status: DeviationType.Done.rawValue)
        }
    }
}


//MARK: APi Work in View controller
extension DeviationVC{
    
    func getDeviation(status: String) -> Void {
        SVProgressHUD.show()
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"status\":\"\(status)\"}"
        print(param)
        
        DeviationsVM.shared.getDeviationsData(parameters: param, isAuthorization: true) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreData = true
            }else{
                self.isMoreData = false
            }
            for model in obj.rows ?? []{
                
                self.arrDeviationsData.append(model)
            }
            self.deviationlisttblVw.reloadData()
        }
    }
    
    func deleteDeviationAPI(id: Int, indePathId : IndexPath) -> Void {
        self.isLoadingList = false
        let param = [String:Any]()
        print(param)
        
        DeviationsVM.shared.deleteDeviationsAPI(parameters: param, id: id, isAuthorization: true) { [self] obj in
            
            arrDeviationsData.remove(at: indePathId.row)
            self.deviationlisttblVw.reloadData()
        }
    }
}
