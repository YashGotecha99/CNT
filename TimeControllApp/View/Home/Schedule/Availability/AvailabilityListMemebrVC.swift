//
//  AvailabilityListMemebrVC.swift
//  TimeControllApp
//
//  Created by yash on 19/01/23.
//

import UIKit
import SVProgressHUD

class AvailabilityListMemebrVC: BaseViewController {
    
    @IBOutlet weak var availabilityTblVw: UITableView!

    var isMoreData : Bool = true
    var isLoadingList : Bool = false

    var arrAllAvailabilityData : [AvailabilityList] = []
    var selectedIndexPath : IndexPath = []

    @IBOutlet weak var availabilityMemberPopUpView: UIView!
    
    //MARK: Localizations
    @IBOutlet weak var availabilityTitleLbl: UILabel!
    
    @IBOutlet weak var staticViewDetailsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
//        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        availabilityTitleLbl.text = LocalizationKey.availability.localizing()
        staticViewDetailsLbl.text = LocalizationKey.viewDetails.localizing()
    }
    
    func configUI() {
        self.availabilityTblVw.separatorColor = UIColor.clear
        availabilityTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.AvailabilityListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AvailabilityListTVC.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        availabilityMemberPopUpView.isHidden = true
        configUI()
        self.arrAllAvailabilityData.removeAll()
        GlobleVariables.page = 0
        getAvailabityListData(filterData: "")
    }
    
    @IBAction func createAvailabilityBtn(_ sender: Any) {
        
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "CreateAvailabilityVC") as! CreateAvailabilityVC
//        vc.availabilityID = 0
        vc.isComingFrom = "Member"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnClickedViewDetails(_ sender: Any) {
        availabilityMemberPopUpView.isHidden = true
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "CreateAvailabilityVC") as! CreateAvailabilityVC
        vc.availabilityID = arrAllAvailabilityData[selectedIndexPath.row].id ?? 0
        vc.isComingFrom = "PMDetails"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnClickedClosePopUpView(_ sender: Any) {
        availabilityMemberPopUpView.isHidden = true
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension AvailabilityListMemebrVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = arrAllAvailabilityData.count
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noAvailability.localizing()
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
        return arrAllAvailabilityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AvailabilityListTVC.rawValue, for: indexPath) as? AvailabilityListTVC else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.setData(availabilityData: arrAllAvailabilityData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        availabilityMemberPopUpView.isHidden = false
    }
    
}

extension AvailabilityListMemebrVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreData  ){
            self.isLoadingList = true
            GlobleVariables.page = GlobleVariables.page + 1
            getAvailabityListData(filterData: "")
        }
    }
}

//MARK: APi Work in View controller
extension AvailabilityListMemebrVC{

    func getAvailabityListData(filterData: String) -> Void {
        SVProgressHUD.show()
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"name\":\"\(filterData)\"}"
        print(param)
        
        AvailabilityVM.shared.getAllAvailabilityData(parameters: param, isAuthorization: true) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreData = true
            }else{
                self.isMoreData = false
            }
            for model in obj.rows ?? []{
                self.arrAllAvailabilityData.append(model)
            }
            self.availabilityTblVw.reloadData()
        }
    }
}
