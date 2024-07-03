//
//  ChatListVC.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 12/04/23.
//

import UIKit

class ChatListVC: BaseViewController {
    
    @IBOutlet weak var chatTitleLbl: UILabel!
    @IBOutlet weak var chatSegmentController: UISegmentedControl!
    
    @IBOutlet weak var projectListtblView: UITableView!
    @IBOutlet weak var createChatForMemberView: UIView!
    
    @IBOutlet weak var btnCreateChat: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    var rooms : [Rooms]?
    
    var privateRooms : [Rooms]?
    
    var selectedIndex = -1
    
    var selectedMemberListIndex = -1

    var selectedRoomId = 0
    var selectedSegment = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        chatTitleLbl.text = LocalizationKey.chat.localizing()
        chatSegmentController.setTitle(LocalizationKey.projectS.localizing(), forSegmentAt: 0)
        chatSegmentController.setTitle(LocalizationKey.memberS.localizing(), forSegmentAt: 1)
        selectBtn.setTitle(LocalizationKey.select.localizing(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobleVariables.page = 0
        
        if chatSegmentController.selectedSegmentIndex == 0 {
            selectedSegment = "Project"
//            createChatForMemberView.isHidden = true
            btnCreateChat.isHidden = true
            getRoomsApi()
        } else {
            selectedSegment = "Member"
//            createChatForMemberView.isHidden = false
            btnCreateChat.isHidden = false
            getPrivateRoomsApi()
        }
    }
    
    func configUI() {
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        chatSegmentController.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        chatSegmentController.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        projectListtblView.register(UINib.init(nibName: TABLE_VIEW_CELL.ProjectListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue)
        projectListtblView.register(UINib.init(nibName: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue)
        
        deleteBtn.isHidden = true
        deleteBtn.imageView?.contentMode = .scaleAspectFit
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
//        projectListtblView.addGestureRecognizer(longPress)
    }
    
    @IBAction func ChangedSegment(_ sender: Any) {
        if chatSegmentController.selectedSegmentIndex == 0 {
            selectedSegment = "Project"
//            createChatForMemberView.isHidden = true
            btnCreateChat.isHidden = true
            deleteBtn.isHidden = true
            self.getRoomsApi()
        } else {
            selectedSegment = "Member"
//            createChatForMemberView.isHidden = false
            btnCreateChat.isHidden = false
            deleteBtn.isHidden = false
            getPrivateRoomsApi()
        }
        selectedIndex = -1
        selectedMemberListIndex = -1
        selectedRoomId = 0
        projectListtblView.reloadData()
    }
    @IBAction func btnCreateChatForMember(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "CreateChatVC") as! CreateChatVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSelectAction(_ sender: UIButton) {
        if selectedRoomId == 0 {
            return
        }
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.roomId = selectedRoomId
        vc.selectedSegmentStr = selectedSegment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        deleteChat()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func deleteChat(){
        print("\(chatSegmentController.selectedSegmentIndex)  \(selectedIndex)")
        if chatSegmentController.selectedSegmentIndex == 1 && selectedMemberListIndex != -1 {
            let alert = UIAlertController(title: "", message: LocalizationKey.deletethisChat.localizing(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                // start work
                self.deletePrivateRoomApi(deleteChatID: self.privateRooms?[self.selectedMemberListIndex].id ?? 0)
            }))
            alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if chatSegmentController.selectedSegmentIndex == 1 {
            if sender.state == .began {
                let touchPoint = sender.location(in: projectListtblView)
                if let indexPath = projectListtblView.indexPathForRow(at: touchPoint) {
                    let alert = UIAlertController(title: "", message: LocalizationKey.deletethisChat.localizing(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                        // start work
                        self.deletePrivateRoomApi(deleteChatID: self.privateRooms?[indexPath.row].id ?? 0)
                    }))
                    alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension ChatListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

//        var count = scheduleListViewModel.scheduleListModel?.shifts?.count ?? 0
        var count = 0
        if chatSegmentController.selectedSegmentIndex == 0 {
            count = rooms?.count ?? 0
        }
        else {
            count = privateRooms?.count ?? 0
        }
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noHistoryHasBeenFound.localizing()
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
        if chatSegmentController.selectedSegmentIndex == 0 {
            return rooms?.count ?? 0
        } else {
            return privateRooms?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatSegmentController.selectedSegmentIndex == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue, for: indexPath) as? ProjectListTVC
            else { return UITableViewCell() }
          
        
            guard  let projectData = rooms?[indexPath.row] else {
                return cell
            }

            cell.setData(data: projectData)
                    
            if selectedIndex == indexPath.row {
                
                cell.btnSelect.setImage(UIImage(named: "selectRadioIcon"), for: .normal)

            }
            else {
                
                cell.btnSelect.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, for: indexPath) as? EmployeeListShiftTVC
            else { return UITableViewCell() }
            cell.selectedEmplyeeRadioBtn.isHidden = false
            cell.selectedEmplyeeRadioBtn.isUserInteractionEnabled = false
            
            guard  let projectData = privateRooms?[indexPath.row] else {
                return cell
            }

            cell.setData(rowsData: projectData)
            if selectedMemberListIndex == indexPath.row {
                cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }
            else {
                cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if chatSegmentController.selectedSegmentIndex == 0 {
            selectedIndex = indexPath.row
            selectedRoomId = rooms?[indexPath.row].id ?? 0
        } else {
            selectedMemberListIndex = indexPath.row
            selectedRoomId = privateRooms?[indexPath.row].id ?? 0
        }
        projectListtblView.reloadData()
    }
    
    /*
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if chatSegmentController.selectedSegmentIndex == 0 {
            
        }
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete action ...")
            success(true)
            self.deletePrivateRoomApi(deleteChatID: self.privateRooms?[indexPath.row].id ?? 0)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
     }
     */
}

//MARK: Extension Api's
extension ChatListVC {
    
    func getRoomsApi(name: String = "") -> Void {
        
        var param = [String:Any]()
        
        ChatVM.shared.getRooms(parameters: param, isAuthorization: true) { [self] obj in
            
           // self.arrProjects = obj
            
            self.rooms = obj.rooms
            
            projectListtblView.reloadData()
        }
    }
    
    func getPrivateRoomsApi(name: String = "") -> Void {
        
        var param = [String:Any]()
        
        ChatVM.shared.getPrivateRooms(parameters: param, isAuthorization: true) { [self] obj in
            
           // self.arrProjects = obj
            
            self.privateRooms = obj.rooms
            
            projectListtblView.reloadData()
        }
    }
    
    func deletePrivateRoomApi(deleteChatID: Int) -> Void {
            
        ChatVM.shared.deletePrivateRoom(id: deleteChatID){ [self] obj in
            getPrivateRoomsApi()
        }
    }
}
