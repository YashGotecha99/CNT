//
//  ChatVC.swift
//  TimeControllApp
//
//  Created by mukesh on 04/08/22.
//

import UIKit
import SocketIO
import WebKit
import IQKeyboardManagerSwift

class ChatVC: BaseViewController {

    var roomId = Int()
    var getRoomData : ChatRoomMessagesModel?
    var allMessages : [LastMessages] = []
    var currentUserId = 0
    @IBOutlet weak var txtMessages: UITextField!
    @IBOutlet weak var chatMessagesTblVw: UITableView!
    var selectedSegmentStr = ""

    var arrAllMessagesData = [[String:Any]]()
    var chatImageID = 0
    @IBOutlet weak var chatImg: UIImageView!
    @IBOutlet weak var crossImg: UIImageView!
    var currentUserName = ""
    var currentUserImage = ""
    var currentUserType = ""
    
    @IBOutlet weak var chatBigImg: UIImageView!
    
    @IBOutlet weak var openWebView: UIView!
    
    @IBOutlet weak var chatTitleLbl: UILabel!
    @IBOutlet weak var tvMessages: UITextView!
    @IBOutlet weak var sendChatMessageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        currentUserId = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
        currentUserName = UserDefaults.standard.string(forKey: UserDefaultKeys.userName) ?? ""
        currentUserImage = UserDefaults.standard.string(forKey: UserDefaultKeys.userImageIdAPI) ?? ""
        currentUserType = UserDefaults.standard.string(forKey: UserDefaultKeys.userType) ?? ""

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Add tap gesture recognizer to dismiss keyboard when tapping outside the text field
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
            
        IQKeyboardManager.shared.enable = false
    }
    
    
    deinit {
            // Unregister for keyboard notifications when the view controller is deallocated
            NotificationCenter.default.removeObserver(self)
        }

        @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                // Adjust the content inset or constraints of your views based on the keyboard height
                // For example:
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - 30, right: 0)
                chatMessagesTblVw.contentInset = contentInset
                chatMessagesTblVw.scrollIndicatorInsets = contentInset
                
                if self.arrAllMessagesData.count > 0 {
                    let indexPath = IndexPath(row: self.arrAllMessagesData.count-1, section: 0)
                    self.chatMessagesTblVw.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
                
                sendChatMessageView.frame.origin.y = self.chatMessagesTblVw.frame.height - keyboardSize.height + 40
                
                chatMessagesTblVw.dataSource = self
                chatMessagesTblVw.delegate = self
            }
        }

        @objc func keyboardWillHide(_ notification: Notification) {
            // Reset the content inset or constraints when the keyboard is hidden
            // For example:
            chatMessagesTblVw.contentInset = .zero
            chatMessagesTblVw.scrollIndicatorInsets = .zero
            sendChatMessageView.frame.origin.y = self.chatMessagesTblVw.frame.height
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    func setUpLocalization(){
        chatTitleLbl.text = LocalizationKey.chat.localizing()
        txtMessages.placeholder = LocalizationKey.iMessage.localizing()
//        tvMessages.placeholder = LocalizationKey.iMessage.localizing()
    }

    func configUI(){
        
        chatMessagesTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SSReceiveLocationTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SSReceiveLocationTVC.rawValue)
        chatMessagesTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SendMessageTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SendMessageTVC.rawValue)
        chatMessagesTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ReceiveTextMessageTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ReceiveTextMessageTVC.rawValue)
        chatMessagesTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SSSendLocationTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SSSendLocationTVC.rawValue)
        chatMessagesTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SendMessageAttachmentsTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SendMessageAttachmentsTVC.rawValue)
        chatMessagesTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ReceiveTextMessageAttachmentTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ReceiveTextMessageAttachmentTVC.rawValue)
        
        chatImg.isHidden = true
        crossImg.isHidden = true
        openWebView.isHidden = true

        if (selectedSegmentStr == "Project") {
            getRoomsIdByMessagesApi(selectedRoomId: self.roomId)
        } else {
            getRoomsIdByPrivateMessagesApi(selectedRoomId: self.roomId)
        }
        chatMessagesTblVw.reloadData()
        self.callingListner()
    }
    
    func callingListner() {
        SocketIoManager.listenMessage(completionHandler: { (messageInfo) -> Void in
            DispatchQueue.main.async {
                if (self.roomId == messageInfo?["room_id"] as! Int) {
                    var temp = messageInfo
                    temp?["timestamp"] = "\(Date())"
                    self.arrAllMessagesData.append(temp ?? [:])
                    self.chatMessagesTblVw.reloadData()
                    let indexPath = IndexPath(row: self.arrAllMessagesData.count-1, section: 0)
                    self.chatMessagesTblVw.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        })
        
        SocketIoManager.listenProjectMessage(completionHandler: { (messageInfo) -> Void in
            DispatchQueue.main.async {
                if (self.roomId == messageInfo?["room_id"] as! Int) {
                    var temp = messageInfo
                    temp?["timestamp"] = "\(Date())"
                    self.arrAllMessagesData.append(temp ?? [:])
                    self.chatMessagesTblVw.reloadData()
                    let indexPath = IndexPath(row: self.arrAllMessagesData.count-1, section: 0)
                    self.chatMessagesTblVw.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        })
    }
    
    @IBAction func crossBtnAction(_ sender: Any) {
        openWebView.isHidden = true
    }
    @IBAction func btnCross(_ sender: Any) {
        chatImg.isHidden = true
        crossImg.isHidden = true
//        txtMessages.isUserInteractionEnabled = true
    }
    
    @IBAction func btnActionSentMessages(_ sender: Any) {
        if (tvMessages.text != "" || chatImageID != 0)  {
            /*
            var param = [String:Any]()
            param["author"] = currentUserId
            param["room"] = getRoomData?.room?.id
            param["message"] = chatImageID == 0 ? txtMessages.text : ""
            param["client_id"] = getRoomData?.room?.client_id
            var data = [String:Any]()
            data["image_id"] = chatImageID == 0 ? 0 : chatImageID
            param["data"] = data
            var author_data = [String:Any]()
            author_data["fullname"] = currentUserName
            author_data["image"] = currentUserImage
            author_data["user_id"] = currentUserId
            author_data["user_type"] = currentUserType
            param["author_data"] = author_data

            print("Chat Param is : ", param)
            
            SocketIoManager.sendMessage(dict: param, selectedSegment: selectedSegmentStr)
            txtMessages.text = ""
            chatImg.isHidden = true
            crossImg.isHidden = true
            txtMessages.isUserInteractionEnabled = true
            txtMessages.resignFirstResponder()
             */
            
            if (chatImageID != 0) {
                sendMessagesWithImage()
            }
//            if (txtMessages.text != "") {
            else {
                sendMessages()
            }
            txtMessages.text = ""
            tvMessages.text = ""
            chatImg.isHidden = true
            crossImg.isHidden = true
            chatImageID = 0
            txtMessages.isUserInteractionEnabled = true
            txtMessages.resignFirstResponder()
            tvMessages.isUserInteractionEnabled = true
            tvMessages.resignFirstResponder()
        }
    }
    func sendMessages() {
        var param = [String:Any]()
        param["author"] = currentUserId
        param["room"] = getRoomData?.room?.id
//        param["message"] = txtMessages.text
        param["message"] = tvMessages.text
        param["client_id"] = getRoomData?.room?.client_id
        var data = [String:Any]()
        data["image_id"] = 0
        param["data"] = data
        var author_data = [String:Any]()
        author_data["fullname"] = currentUserName
        author_data["image"] = currentUserImage
        author_data["user_id"] = currentUserId
        author_data["user_type"] = currentUserType
        param["author_data"] = author_data

        print("Chat Param is sendMessages : ", param)
        
        SocketIoManager.sendMessage(dict: param, selectedSegment: selectedSegmentStr)
//        txtMessages.text = ""
//        chatImg.isHidden = true
//        crossImg.isHidden = true
//        txtMessages.isUserInteractionEnabled = true
//        txtMessages.resignFirstResponder()
    }
    
    func sendMessagesWithImage() {
        var param = [String:Any]()
        param["author"] = currentUserId
        param["room"] = getRoomData?.room?.id
        param["message"] = tvMessages.text
        param["client_id"] = getRoomData?.room?.client_id
        var data = [String:Any]()
        data["image_id"] = chatImageID
        param["data"] = data
        var author_data = [String:Any]()
        author_data["fullname"] = currentUserName
        author_data["image"] = currentUserImage
        author_data["user_id"] = currentUserId
        author_data["user_type"] = currentUserType
        param["author_data"] = author_data

        print("Chat Param is sendMessagesWithImage : ", param)
        
        SocketIoManager.sendMessage(dict: param, selectedSegment: selectedSegmentStr)
//        txtMessages.text =  ""
//        chatImg.isHidden = true
//        crossImg.isHidden = true
//        txtMessages.isUserInteractionEnabled = true
//        txtMessages.resignFirstResponder()
    }
    
    @IBAction func btnActionAttachments(_ sender: Any) {
        ImagePickerManager().pickImage(self){ [self] image,path  in
            chatImg.isHidden = false
//            txtMessages.isUserInteractionEnabled = false
//            let imageData:NSData = image.pngData()! as NSData
            let imageData:NSData = image.jpegData(compressionQuality: 0.1)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            AllUsersVM.shared.saveUserAttachment(imageId: "\(currentUserId)", imageData: strBase64, fileName: path, type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                    print("Image upload successfully")
                self.chatImg.image = image
                self.chatImageID = attachIds
                self.crossImg.isHidden = false
            }
        }
    }
    
}

// MARK:- TableView Delegate & DataSource Method
extension ChatVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllMessagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = arrAllMessagesData[indexPath.row]["timestamp"] as? String
        var dispayTextForDate = ""
        if indexPath.row > 0 {
            let PDate = arrAllMessagesData[indexPath.row - 1]["timestamp"] as? String
            if date?.convertAllFormater(formated: "EEEE MMM dd,yyyy") == PDate?.convertAllFormater(formated: "EEEE MMM dd,yyyy") {
                dispayTextForDate = ""
            } else {
                dispayTextForDate = date?.convertAllFormater(formated: "EEEE MMM dd,yyyy") ?? ""
            }
            
        } else {
            dispayTextForDate = date?.convertAllFormater(formated: "EEEE MMM dd,yyyy") ?? ""
        }
        
        let imageData = arrAllMessagesData[indexPath.row]["data"] as? LastMessageData
        var imageDataWithID = Int()
        if (imageData == nil) {
            let imageData = arrAllMessagesData[indexPath.row]["data"] as? [String:Any]
            imageDataWithID = imageData?["image_id"] as! Int
        } else {
            imageDataWithID = imageData?.image_id ?? 0
        }
        
        if (arrAllMessagesData[indexPath.row]["author_id"] as! Int == currentUserId) {
            
//            if (arrAllMessagesData[indexPath.row]["message"] as? String == "" || arrAllMessagesData[indexPath.row]["message"] as? String == nil) {
            if (imageDataWithID != 0) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SendMessageAttachmentsTVC.rawValue, for: indexPath) as? SendMessageAttachmentsTVC else { return UITableViewCell() }
                cell.sentMsgLbl.text = arrAllMessagesData[indexPath.row]["message"] as? String
                
                //MARK: Change the time formate from configuration
//                cell.msgTimingLbl.text = date?.convertAllFormater(formated: "h:mm a")
                cell.msgTimingLbl.text = date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format ?? "")
                cell.dateLbl.text = dispayTextForDate
                
                let imageData = arrAllMessagesData[indexPath.row]["data"] as? LastMessageData
                let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                if (imageData == nil) {
                    let imageData = arrAllMessagesData[indexPath.row]["data"] as? [String:Any]
                    let urlAttachment = URL(string: strUrl + "/\(imageData?["image_id"] ?? 0)")
                    cell.attachmentImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                } else {
                    let urlAttachment = URL(string: strUrl + "/\(imageData?.image_id ?? 0)")
                    cell.attachmentImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                }
                print("SendMessageAttachmentsTVC : ")
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SendMessageTVC.rawValue, for: indexPath) as? SendMessageTVC else { return UITableViewCell() }
            cell.sentMsgLbl.text = arrAllMessagesData[indexPath.row]["message"] as? String
            //MARK: Change the time formate from configuration
//            cell.msgTimingLbl.text = date?.convertAllFormater(formated: "h:mm a")
            cell.msgTimingLbl.text = date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format ?? "")

            cell.dateLbl.text = dispayTextForDate
            print("SendMessageTVC : ")
            return cell
        }
        else if (arrAllMessagesData[indexPath.row]["author_id"] as! Int != currentUserId && imageDataWithID != 0) {
//                 arrAllMessagesData[indexPath.row]["message"] as? String == "" || arrAllMessagesData[indexPath.row]["message"] as? String == nil) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ReceiveTextMessageAttachmentTVC.rawValue, for: indexPath) as? ReceiveTextMessageAttachmentTVC else { return UITableViewCell() }
            cell.receiveMsgLbl.text = arrAllMessagesData[indexPath.row]["message"] as? String
            
            //MARK: Change the time formate from configuration
//            cell.msgTimingLbl.text = date?.convertAllFormater(formated: "h:mm a")
            cell.msgTimingLbl.text = date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format ?? "")
            cell.dateLbl.text = dispayTextForDate
            
            let imageData = arrAllMessagesData[indexPath.row]["data"] as? LastMessageData
            let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
            if (imageData == nil) {
                let imageData = arrAllMessagesData[indexPath.row]["data"] as? [String:Any]
                let urlAttachment = URL(string: strUrl + "/\(imageData?["image_id"] ?? 0)")
                cell.receiveAttachmnetImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            } else {
                let urlAttachment = URL(string: strUrl + "/\(imageData?.image_id ?? 0)")
                cell.receiveAttachmnetImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            }
            
            let authData = arrAllMessagesData[indexPath.row]["author_data"] as? Author_data
            if (authData == nil) {
                let authData = arrAllMessagesData[indexPath.row]["author_data"] as? [String:Any]
                cell.usernameLbl.text = authData?["fullname"] as? String
                let url = URL(string: strUrl + "/\(authData?["image"] ?? "")")
                cell.receiveMsgUserImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            } else {
                cell.usernameLbl.text = authData?.fullname
                let url = URL(string: strUrl + "/\(authData?.image ?? "")")
                cell.receiveMsgUserImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            }
            print("ReceiveTextMessageAttachmentTVC : ")

            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ReceiveTextMessageTVC.rawValue, for: indexPath) as? ReceiveTextMessageTVC else { return UITableViewCell() }
        cell.receiveMsgLbl.text = arrAllMessagesData[indexPath.row]["message"] as? String
        
        //MARK: Change the time formate from configuration
//        cell.msgTimingLbl.text = date?.convertAllFormater(formated: "h:mm a")
        cell.msgTimingLbl.text = date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format ?? "")
        cell.dateLbl.text = dispayTextForDate
        
        let authData = arrAllMessagesData[indexPath.row]["author_data"] as? Author_data
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        if (authData == nil) {
            let authData = arrAllMessagesData[indexPath.row]["author_data"] as? [String:Any]
            cell.usernameLbl.text = authData?["fullname"] as? String
            let url = URL(string: strUrl + "/\(authData?["image"] ?? "")")
            cell.receiveMsgUserImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        } else {
            cell.usernameLbl.text = authData?.fullname
            let url = URL(string: strUrl + "/\(authData?.image ?? "")")
            cell.receiveMsgUserImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        }
        print("ReceiveTextMessageTVC : ")

//        cell.usernameLbl.text = authData?.fullname
//        let url = URL(string: API.SAVEATTACHMENT + "/\(authData?.image ?? "")")
//        cell.receiveMsgUserImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        if (arrAllMessagesData[indexPath.row]["author_id"] as! Int == currentUserId) {
            //            if (arrAllMessagesData[indexPath.row]["message"] as? String == "" || arrAllMessagesData[indexPath.row]["message"] as? String == nil) {
            let imageData = arrAllMessagesData[indexPath.row]["data"] as? LastMessageData
            var imageDataWithID = Int()
            if (imageData == nil) {
                let imageData = arrAllMessagesData[indexPath.row]["data"] as? [String:Any]
                imageDataWithID = imageData?["image_id"] as! Int
                if imageDataWithID != 0 {
                    let urlAttachment = URL(string: strUrl + "/\(imageData?["image_id"] ?? 0)")
                    chatBigImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                    if UIApplication.shared.canOpenURL(urlAttachment!) {
                        UIApplication.shared.open(urlAttachment!, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }
            } else {
                imageDataWithID = imageData?.image_id ?? 0
                if imageDataWithID != 0 {
                    let urlAttachment = URL(string: strUrl + "/\(imageData?.image_id ?? 0)")
                    chatBigImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                    if UIApplication.shared.canOpenURL(urlAttachment!) {
                        UIApplication.shared.open(urlAttachment!, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }
            }
            //            }
        }
        else if (arrAllMessagesData[indexPath.row]["author_id"] as! Int != currentUserId) {
            
            //                 && arrAllMessagesData[indexPath.row]["message"] as? String == "" || arrAllMessagesData[indexPath.row]["message"] as? String == nil) {
            let imageData = arrAllMessagesData[indexPath.row]["data"] as? LastMessageData
            var imageDataWithID = Int()
            if (imageData == nil) {
                let imageData = arrAllMessagesData[indexPath.row]["data"] as? [String:Any]
                imageDataWithID = imageData?["image_id"] as! Int
                if imageDataWithID != 0 {
                    let urlAttachment = URL(string: strUrl + "/\(imageData?["image_id"] ?? 0)")
                    chatBigImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                    if UIApplication.shared.canOpenURL(urlAttachment!) {
                        UIApplication.shared.open(urlAttachment!, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }
            } else {
                imageDataWithID = imageData?.image_id ?? 0
                if imageDataWithID != 0 {
                    let urlAttachment = URL(string: strUrl + "/\(imageData?.image_id ?? 0)")
                    chatBigImg.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                    if UIApplication.shared.canOpenURL(urlAttachment!) {
                        UIApplication.shared.open(urlAttachment!, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }
            }
            //            let authData = arrAllMessagesData[indexPath.row]["author_data"] as? Author_data
            //            if (authData == nil) {
            //                let authData = arrAllMessagesData[indexPath.row]["author_data"] as? [String:Any]
            //                let url = URL(string: API.SAVEATTACHMENT + "/\(authData?["image"] ?? "")")
            //                chatBigImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            //            } else {
            //                let url = URL(string: API.SAVEATTACHMENT + "/\(authData?.image ?? "")")
            //                chatBigImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            //            }
        }
//        openWebView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: Extension Api's
extension ChatVC {
    
    func getRoomsIdByMessagesApi(selectedRoomId: Int) -> Void {
        let param = [String:Any]()
        ChatVM.shared.getRoomIdFromMessages(parameters: param, id: selectedRoomId, isAuthorization: true) { [self] obj in

            self.getRoomData = obj
            self.allMessages = obj.lastMessages ?? []
            self.allMessages.reverse()
            for index in 0..<self.allMessages.count {
                var allMessagesDetails = [String:Any]()
                allMessagesDetails["id"] = self.allMessages[index].id
                allMessagesDetails["message"] = self.allMessages[index].message
                allMessagesDetails["room_id"] = self.allMessages[index].room_id
//                allMessagesDetails["author"] = self.allMessages[index].author
                allMessagesDetails["author_id"] = self.allMessages[index].author
                allMessagesDetails["timestamp"] = self.allMessages[index].timestamp
                allMessagesDetails["author_data"] = self.allMessages[index].author_data
                allMessagesDetails["data"] = self.allMessages[index].data
                self.arrAllMessagesData.append(allMessagesDetails)
            }
            chatMessagesTblVw.reloadData()
            if self.arrAllMessagesData.count > 0 {
                let indexPath = IndexPath(row: self.arrAllMessagesData.count-1, section: 0)
                chatMessagesTblVw.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func getRoomsIdByPrivateMessagesApi(selectedRoomId: Int) -> Void {
        let param = [String:Any]()
        ChatVM.shared.getRoomIdFromPrivateMessages(parameters: param, id: selectedRoomId, isAuthorization: true) { [self] obj in

            self.getRoomData = obj
            self.allMessages = obj.lastMessages ?? []
            self.allMessages.reverse()
            for index in 0..<self.allMessages.count {
                var allMessagesDetails = [String:Any]()
                allMessagesDetails["id"] = self.allMessages[index].id
                allMessagesDetails["message"] = self.allMessages[index].message
                allMessagesDetails["room_id"] = self.allMessages[index].room_id
//                allMessagesDetails["author"] = self.allMessages[index].author
                allMessagesDetails["author_id"] = self.allMessages[index].author
                allMessagesDetails["timestamp"] = self.allMessages[index].timestamp
                allMessagesDetails["author_data"] = self.allMessages[index].author_data
                allMessagesDetails["data"] = self.allMessages[index].data
                self.arrAllMessagesData.append(allMessagesDetails)
            }
            chatMessagesTblVw.reloadData()
            if self.arrAllMessagesData.count > 0 {
                let indexPath = IndexPath(row: self.arrAllMessagesData.count-1, section: 0)
                chatMessagesTblVw.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}
