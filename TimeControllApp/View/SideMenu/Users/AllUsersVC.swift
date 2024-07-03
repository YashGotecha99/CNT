//
//  AllUsersVC.swift
//  TimeControllApp
//
//  Created by mukesh on 31/07/22.
//

import UIKit

class AllUsersVC: BaseViewController {

    @IBOutlet weak var usersTitleLbl: UILabel!
    @IBOutlet weak var userListTblVw: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    var arrUserListRows : [UserList] = []
    var currentPage = 0
    var totalPage = 0
    var searchStr = ""
    
    
    var isMoreUser : Bool = true
    var isLoadingList : Bool = false
    var searchTask: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        usersTitleLbl.text = LocalizationKey.users.localizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrUserListRows.removeAll()
        GlobleVariables.page = 0
        hitGetAllUsersApi(filterData: searchTxt.text ?? "")
    }

    func configUI() {
        userListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.EmployeeListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EmployeeListTVC.rawValue)
        
        userListTblVw.reloadData()
    }

    @IBAction func addUserBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddUserVC") as! AddUserVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension AllUsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserListRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListTVC.rawValue, for: indexPath) as? EmployeeListTVC
        else { return UITableViewCell() }
        cell.userNumberLbl.isHidden = false
        cell.selectedEmplyeeRadioBtn.isHidden = true
        cell.userStatusLbl.layer.cornerRadius = 10
        cell.userStatusLbl.layer.masksToBounds = true
        cell.selectionStyle = .none
//
//        guard  let rowsData = arrUserListRows[indexPath.row] else {
//            return cell
//        }
//        cell.userName.text = arrUserListRows?[indexPath.row].first_name ?? ""
        cell.setData(rowsData: arrUserListRows[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "UserProfileDetailsVC") as! UserProfileDetailsVC
        vc.userID = String(arrUserListRows[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AllUsersVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        arrUserListRows.removeAll()
        //        searchStr = searchTxt.text ?? ""
        //        guard let textRange = Range(range, in: searchStr) else {
        //            return false
        //        }
        //        searchStr = searchStr.replacingCharacters(in: textRange, with: string)
        //        hitGetAllUsersApi(filterData: searchStr)
        //        return true
        
        var searchText = searchTxt.text!
        if let r = Range(range, in: searchText){
            searchText.removeSubrange(r) // it will delete any deleted string.
        }
        searchText.insert(contentsOf: string, at: searchText.index(searchText.startIndex, offsetBy: range.location)) // it will insert any text.
        print("searchText",searchText)
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.arrUserListRows.removeAll()
            GlobleVariables.page = 0
            self?.hitGetAllUsersApi(filterData: searchText)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
        return true
    }
}

extension AllUsersVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreUser  ){
            self.isLoadingList = true
            GlobleVariables.page = GlobleVariables.page + 1
            hitGetAllUsersApi(filterData: searchTxt.text ?? "")
        }
    }
}

//MARK: All User List Api's

extension AllUsersVC {
        
    func hitGetAllUsersApi(filterData: String) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"name\":\"\(filterData)\"}"
        param["mode"] = "members"
        print(param)
        AllUsersVM.shared.getAllUsersApi(parameters: param, isAuthorization: true) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreUser = true
            }else{
                self.isMoreUser = false
            }
            for model in obj.rows ?? []{
                self.arrUserListRows.append(model)
            }
            self.userListTblVw.reloadData()
        }
    }
}

