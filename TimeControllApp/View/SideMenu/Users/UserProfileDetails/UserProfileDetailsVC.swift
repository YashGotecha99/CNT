//
//  UserProfileDetailsVC.swift
//  TimeControllApp
//
//  Created by prashant on 02/02/23.
//

import UIKit

class UserProfileDetailsVC: BaseViewController, UIDocumentPickerDelegate {

    // MARK:- CollectionView Declared
    
    @IBOutlet weak var spokenLanguageCollectionView: UICollectionView!
    @IBOutlet weak var equipmentCollectionView: UICollectionView!
    @IBOutlet weak var assignProjectsCollectionView: UICollectionView!
    @IBOutlet weak var selectProjectCollectionView: UICollectionView!
    @IBOutlet weak var uploadImageCollectionView: UICollectionView!
    
    // MARK:- Profile Image Outlets
    
    @IBOutlet weak var userProfileSclv: UIScrollView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var activeDeactiveSwitch: UISwitch!
    
    // MARK:- Personal Information Outlets
    
    @IBOutlet weak var personalInformationEditBtn: UIButton!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var dateOfBirthTxt: UITextField!
    @IBOutlet weak var ssmTxt: UITextField!
    @IBOutlet weak var nationalityTxt: UITextField!
    @IBOutlet weak var employeeTypeTxt: UITextField!
    @IBOutlet weak var spokenLanguageTxt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var maleRadioBtn: UIButton!
    @IBOutlet weak var femaleRadioBtn: UIButton!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateOfBirthBtn: UIButton!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    
    // MARK:- Address Information Outlets
    
    @IBOutlet weak var addressInformationEditBtn: UIButton!
    @IBOutlet weak var fullAddressTxt: UITextField!
    @IBOutlet weak var zipCodeTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var addressInformationSaveBtn: UIButton!
    
    // MARK:- Access Information Outlets
    
    @IBOutlet weak var accessInformationEditBtn: UIButton!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var userRoleTxt: UITextField!
    @IBOutlet weak var employeeIDTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var pinTxt: UITextField!
    @IBOutlet weak var numberOfHolidaysTxt: UITextField!
    @IBOutlet weak var equipmentPlusBtn: UIButton!
    @IBOutlet weak var equipmentTxt: UITextField!
    @IBOutlet weak var accessInformationSaveBtn: UIButton!
    @IBOutlet weak var disableLogsSwitch: UISwitch!
    
    // MARK:- Payment Terms Outlets
    @IBOutlet weak var paymentTermsEditBtn: UIButton!
    @IBOutlet weak var grossRateTxt: UITextField!
    @IBOutlet weak var hourlyRateTxt: UITextField!
    @IBOutlet weak var startDateTxt: UITextField!
    @IBOutlet weak var workHoursTxt: UITextField!
    @IBOutlet weak var numberOfHolidayTxt: UITextField!
    @IBOutlet weak var assignProjectTxt: UITextField!
    @IBOutlet weak var paymentTermsSaveBtn: UIButton!
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var assignProjectBtn: UIButton!
    
    // MARK:- Bank Information Outlets
    @IBOutlet weak var bankInformationEditBtn: UIButton!
    @IBOutlet weak var bankNameTxt: UITextField!
    @IBOutlet weak var accountHolderNameTxt: UITextField!
    @IBOutlet weak var accountNumberTxt: UITextField!
    @IBOutlet weak var bankInformationSaveBtn: UIButton!
    
    // MARK:- About Information Outlets
    @IBOutlet weak var aboutEditAction: UIButton!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var aboutSaveBtn: UIButton!
    @IBOutlet weak var aboutTv: UITextView!
    
    // MARK:- Attachments Outlets
    @IBOutlet weak var attachmentTxt: UITextField!
    @IBOutlet weak var selectProjectBtn: UIButton!
    
    // MARK:- Static Outlets
    @IBOutlet weak var usersTitleLbl: UILabel!
    @IBOutlet weak var deactivateUserLbl: UILabel!
    @IBOutlet weak var personalInformationLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var dateOfBirthLbl: UILabel!
    @IBOutlet weak var ssnLbl: UILabel!
    @IBOutlet weak var addressInformationLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var accessInformationLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userRoleLbl: UILabel!
    @IBOutlet weak var employeeIdLbl: UILabel!
    @IBOutlet weak var pinLbl: UILabel!
    @IBOutlet weak var numberofHolidaysLbl: UILabel!
    @IBOutlet weak var disableAutoLogLbl: UILabel!
    @IBOutlet weak var paymentTermsLbl: UILabel!
    @IBOutlet weak var grossRateLbl: UILabel!
    @IBOutlet weak var hourlyFixedRateLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var assignProjectLbl: UILabel!
    @IBOutlet weak var documentAndContractLbl: UILabel!
    @IBOutlet weak var attachmentLbl: UILabel!
    
    // MARK:- Others Properties Declaration
    var selectedNationality: String?
    let pickerView = UIPickerView()
    var NationalityList = ["Afghan", "Albanian", "Danish", "Indian", "Malawian", "Thailand"]
    var EmploymentTypeList = ["Manager", "Member", "Accountant", "Operation", "Sales", "Marketing"]
    var SpokenLanguageList = ["English", "Danish", "Arabic", "Russian", "Spanish", "Japanese"]
    var selectedSpokenLanguage : String?
    var selectedSpokenLanguageListData = ["English"]
    var equipmentListData = ["Laptop"]
    var dateSelected = ""
    
    var assignProjectList = [String] ()
    var selectedAssignProjectsListData = [String] ()
    
    var selectDocumentList = [String] ()
    var selectedDocumentsListData = [String] ()

    let assignProjectDropdown = DropDown()
    let selectDocumentDropdown = DropDown()

    var imagePickerController = UIImagePickerController()

    var userID = String()
    var arrManageProjectList : [projectsModel] = []
    var assignProjectsSelectedRowIndicesArray = Set<intIndex>()
    
    var userProfileData : UserDetails?
    var userImageID = ""
    var arrDocumentsList : [Document_templates] = []
    
    var attachmentArray : [AttachmentsData] = []
    var uploadAttachmentsArray = ""
    var uploadAttachmentsArrayData = [String] ()
    var uploadLatestID = ""
    var strDeactiveUser = ""
    var strDisableLog = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("User id : ", UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "")
        // MARK:- Collectionview Declared
        
        self.spokenLanguageCollectionView.delegate = self
        self.spokenLanguageCollectionView.dataSource = self

        equipmentCollectionView.delegate = self
        equipmentCollectionView.dataSource = self

        assignProjectsCollectionView.delegate = self
        assignProjectsCollectionView.dataSource = self

        selectProjectCollectionView.delegate = self
        selectProjectCollectionView.dataSource = self

        uploadImageCollectionView.delegate = self
        uploadImageCollectionView.dataSource = self
        
        // MARK:- DatePicker Declared
        
        datePickerView.isHidden = true
        
        // MARK:- UIPicker Declared
        pickerView.delegate = self
//        createPickerView()
        dismissPickerView()
        setUpLocalization()
        hitGetUsersDetailsApi(id: userID)
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        usersTitleLbl.text = LocalizationKey.users.localizing()
        deactivateUserLbl.text = LocalizationKey.deactivateUser.localizing()
        personalInformationLbl.text = LocalizationKey.personalInformation.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        nameLbl.text = LocalizationKey.name.localizing()
        emailLbl.text = LocalizationKey.email.localizing()
        phoneLbl.text = LocalizationKey.phone.localizing()
        dateOfBirthLbl.text = LocalizationKey.dateOfBirth.localizing()
        ssnLbl.text = LocalizationKey.sSN.localizing()

        addressInformationLbl.text = LocalizationKey.addressInformation.localizing()
        addressLbl.text = LocalizationKey.address.localizing()
        zipCodeLbl.text = LocalizationKey.zipCode.localizing()
        cityLbl.text = LocalizationKey.city.localizing()
        addressInformationSaveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        accessInformationLbl.text = LocalizationKey.accessInformation.localizing()
        userNameLbl.text = LocalizationKey.username.localizing()
        userRoleLbl.text = LocalizationKey.userRole.localizing()
        employeeIdLbl.text = LocalizationKey.employeeID.localizing()
        pinLbl.text = LocalizationKey.pin.localizing()
        numberofHolidaysLbl.text = LocalizationKey.numberOfHolidays.localizing()
        disableAutoLogLbl.text = LocalizationKey.disableAutoLog.localizing()
        accessInformationSaveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        paymentTermsLbl.text = LocalizationKey.paymentTerms.localizing()
        grossRateLbl.text = LocalizationKey.grossRate.localizing()
        hourlyFixedRateLbl.text = LocalizationKey.hourlyFixedRate.localizing()
        startDateLbl.text = LocalizationKey.startDate.localizing()
        assignProjectLbl.text = LocalizationKey.assignProjects.localizing()
        assignProjectTxt.text = LocalizationKey.selectProject.localizing()
        paymentTermsSaveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        documentAndContractLbl.text = LocalizationKey.documentsAndContractS.localizing()
        attachmentLbl.text = LocalizationKey.attachmentS.localizing()
        
    }
    
    // MARK:- Config the UI

//    func configUI() {
//        self.fullnameTxt.text = self.
//    }
    
    // MARK:- Personal Information Actions

    @IBAction func uploadUserImageClickAction(_ sender: Any) {
        ImagePickerManager().pickImage(self){ [self] image,path  in
            print(path)
            userImage.image = image
//            let imageData:NSData = image.pngData()! as NSData
            let imageData:NSData = image.jpegData(compressionQuality: 0.1)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            print("Base 64 is : ", strBase64)
            AllUsersVM.shared.saveUserAttachment(imageId: userID, imageData: strBase64, fileName: path, type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                    print("User image upload successfully")
                self.userImageID = String(attachIds)
                self.hitProfileSave()
            }
        }
    }
    
    @IBAction func deactiveUserSwichAction(_ sender: Any) {
        if ((sender as AnyObject).isOn) {
            strDeactiveUser = "active"
        }
        else{
            strDeactiveUser = "deactive"
        }
    }
    
    @IBAction func personalInformationEditAction(_ sender: Any) {
        personalInformationEditBtn.isHidden = true
        fullnameTxt.isUserInteractionEnabled = true
        emailTxt.isUserInteractionEnabled = true
        phoneTxt.isUserInteractionEnabled = true
//        dateOfBirthTxt.isUserInteractionEnabled = true
        dateOfBirthBtn.isUserInteractionEnabled = true
        ssmTxt.isUserInteractionEnabled = true
        nationalityTxt.isUserInteractionEnabled = true
        employeeTypeTxt.isUserInteractionEnabled = true
        spokenLanguageTxt.isUserInteractionEnabled = true
        maleRadioBtn.isUserInteractionEnabled = true
        femaleRadioBtn.isUserInteractionEnabled = true
        saveBtn.isHidden = false
    }
    
    @IBAction func dateOfBirthAction(_ sender: Any) {
        datePicker.maximumDate = Date()
        dateSelected = "DOB"
        datePickerView.isHidden = false
    }
    
    @IBAction func maleBtnAction(_ sender: Any) {
        maleRadioBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        femaleRadioBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        maleLbl.textColor = VBColorEnum.BlackColor.getColor()
        femaleLbl.textColor = VBColorEnum.DarkGrayColor.getColor()
        maleLbl.font = UIFont(name: "Inter-SemiBold", size: 15.0)
        femaleLbl.font = UIFont(name: "Inter-Regular", size: 15.0)
    }
    
    @IBAction func femaleBtnAction(_ sender: Any) {
        maleRadioBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        femaleRadioBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        maleLbl.textColor = VBColorEnum.DarkGrayColor.getColor()
        femaleLbl.textColor = VBColorEnum.BlackColor.getColor()
        maleLbl.font = UIFont(name: "Inter-Regular", size: 15.0)
        femaleLbl.font = UIFont(name: "Inter-SemiBold", size: 15.0)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        personalInformationEditBtn.isHidden = false
        fullnameTxt.isUserInteractionEnabled = false
        emailTxt.isUserInteractionEnabled = false
        phoneTxt.isUserInteractionEnabled = false
//        dateOfBirthTxt.isUserInteractionEnabled = false
        dateOfBirthBtn.isUserInteractionEnabled = false
        ssmTxt.isUserInteractionEnabled = false
        nationalityTxt.isUserInteractionEnabled = false
        employeeTypeTxt.isUserInteractionEnabled = false
        spokenLanguageTxt.isUserInteractionEnabled = false
        maleRadioBtn.isUserInteractionEnabled = false
        femaleRadioBtn.isUserInteractionEnabled = false
        saveBtn.isHidden = true
        self.hitProfileSave()
    }
    
    @IBAction func datePickerDoneBtnAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let chooseDate = dateFormatter.string(from: datePicker.date)
        dateSelected == "DOB" ? (dateOfBirthTxt.text = chooseDate) : (startDateTxt.text = chooseDate)
        datePickerView.isHidden = true
    }
    
    // MARK:- Address Information Actions
    
    @IBAction func addressInformationEditAction(_ sender: Any) {
        addressInformationEditBtn.isHidden = true
        fullAddressTxt.isUserInteractionEnabled = true
        zipCodeTxt.isUserInteractionEnabled = true
        cityTxt.isUserInteractionEnabled = true
        addressInformationSaveBtn.isHidden = false
    }
    
    @IBAction func addressInformationSaveBtnAction(_ sender: Any) {
        addressInformationEditBtn.isHidden = false
        fullAddressTxt.isUserInteractionEnabled = false
        zipCodeTxt.isUserInteractionEnabled = false
        cityTxt.isUserInteractionEnabled = false
        addressInformationSaveBtn.isHidden = true
        self.hitProfileSave()
    }
    
    // MARK:- Access Information Actions
    
    @IBAction func accessInformationEditAction(_ sender: Any) {
        accessInformationEditBtn.isHidden = true
        userNameTxt.isUserInteractionEnabled = true
        userRoleTxt.isUserInteractionEnabled = true
        employeeIDTxt.isUserInteractionEnabled = true
        passwordTxt.isUserInteractionEnabled = true
        pinTxt.isUserInteractionEnabled = true
        numberOfHolidaysTxt.isUserInteractionEnabled = true
        equipmentPlusBtn.isUserInteractionEnabled = true
        equipmentTxt.isUserInteractionEnabled = true
        accessInformationSaveBtn.isHidden = false
    }
    
    @IBAction func equipmentPlusAction(_ sender: Any) {
        let itemExists = checkItemInList(items: equipmentListData, itemName: equipmentTxt.text ?? "")
        if itemExists {
            Toast.show(message: LocalizationKey.equipmentAllreadyAvailableInTheList.localizing(), controller: self)
        }
        else {
            equipmentListData.append(equipmentTxt.text ?? "")
            equipmentTxt.text = ""
            equipmentCollectionView.reloadData()
        }
    }
    
    @IBAction func disableAutoLogSwitchAction(_ sender: Any) {
        if ((sender as AnyObject).isOn) {
            strDisableLog = true
        }
        else{
            strDisableLog = false
        }
    }
    
    @IBAction func accessInformationSaveBtnAction(_ sender: Any) {
        accessInformationEditBtn.isHidden = false
        userNameTxt.isUserInteractionEnabled = false
        userRoleTxt.isUserInteractionEnabled = false
        employeeIDTxt.isUserInteractionEnabled = false
        passwordTxt.isUserInteractionEnabled = false
        pinTxt.isUserInteractionEnabled = false
        numberOfHolidaysTxt.isUserInteractionEnabled = false
        equipmentPlusBtn.isUserInteractionEnabled = false
        equipmentTxt.isUserInteractionEnabled = false
        accessInformationSaveBtn.isHidden = true
        self.hitProfileSave()
    }
    
    // MARK:- Payment Terms Actions

    @IBAction func paymentTermsEditAction(_ sender: Any) {
        paymentTermsEditBtn.isHidden = true
        grossRateTxt.isUserInteractionEnabled = true
        hourlyRateTxt.isUserInteractionEnabled = true
        startDateTxt.isUserInteractionEnabled = true
        startDateBtn.isUserInteractionEnabled = true
        workHoursTxt.isUserInteractionEnabled = true
        numberOfHolidayTxt.isUserInteractionEnabled = true
//        assignProjectTxt.isUserInteractionEnabled = true
        paymentTermsSaveBtn.isHidden = false
        assignProjectBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func paymentTermsSaveBtnAction(_ sender: Any) {
        paymentTermsEditBtn.isHidden = false
        grossRateTxt.isUserInteractionEnabled = false
        hourlyRateTxt.isUserInteractionEnabled = false
        startDateTxt.isUserInteractionEnabled = false
        startDateBtn.isUserInteractionEnabled = false
        workHoursTxt.isUserInteractionEnabled = false
        numberOfHolidayTxt.isUserInteractionEnabled = false
//        assignProjectTxt.isUserInteractionEnabled = false
        paymentTermsSaveBtn.isHidden = true
        assignProjectBtn.isUserInteractionEnabled = false
        self.hitProfileSave()
    }
    
    @IBAction func startDateBtnAction(_ sender: Any) {
        datePickerView.isHidden = false
        dateSelected = "SD"
    }
    
    @IBAction func assignProjectBtnAction(_ sender: Any) {
        self.assignProjectDropdown.show()
    }
    
    // MARK:- Bank Information Actions

    @IBAction func bankInformationEditAction(_ sender: Any) {
        bankInformationEditBtn.isHidden = true
        bankNameTxt.isUserInteractionEnabled = true
        accountHolderNameTxt.isUserInteractionEnabled = true
        accountNumberTxt.isUserInteractionEnabled = true
        bankInformationSaveBtn.isHidden = false
    }
    
    @IBAction func bankInformationSaveBtnAction(_ sender: Any) {
        bankInformationEditBtn.isHidden = true
        bankNameTxt.isUserInteractionEnabled = false
        accountHolderNameTxt.isUserInteractionEnabled = false
        accountNumberTxt.isUserInteractionEnabled = false
        bankInformationSaveBtn.isHidden = true
    }
    
    // MARK:- About Actions

    @IBAction func aboutEditAction(_ sender: Any) {
        aboutEditAction.isHidden = true
        aboutSaveBtn.isHidden = false
        aboutLbl.isHidden = true
        aboutTv.isHidden = false
    }
    
    @IBAction func aboutSaveBtnAction(_ sender: Any) {
        aboutEditAction.isHidden = false
        aboutSaveBtn.isHidden = true
        aboutLbl.isHidden = false
        aboutTv.isHidden = true
    }
    
    // MARK:- Upload Documents Actions

    @IBAction func uploadDocumentBtnAction(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .text, .gif, .pdf, .rtf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen

        present(documentPicker, animated: true)
        
//        ImagePickerManager().pickImage(self){ [self] image,path  in
//            print(path)
////            userImage.image = image
//            let imageData:NSData = image.pngData()! as NSData
//            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//            print("Base 64 is : ", strBase64)
//            AllUsersVM.shared.saveUserAttachment(imageId: userID, imageData: strBase64, fileName: path, type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
//                print("User attachment upload successfully")
//                if (self.uploadAttachmentsArray == ""){
//                    self.uploadAttachmentsArray = String(attachIds)
//                }
//                else {
//                    self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
//                }
//                self.uploadAttachmentsArrayData.append(String(attachIds))
//                uploadImageCollectionView.reloadData()
//                self.hitProfileSave()
//            }
//        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

    }

//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urls: URL) {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        dismiss(animated: true)

//        guard url.startAccessingSecurityScopedResource() else {
//            return
//        }
//
//        do {
//            url.stopAccessingSecurityScopedResource()
//        }
        // Copy the file with FileManager
        print("Documnet URL is : ", urls)
        
        let url: NSURL = (urls[0] as? NSURL)!
        let fileExtension = url.pathExtension
        var filetension = url.lastPathComponent
        filetension = filetension?.replacingOccurrences(of: "", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        var myData = NSData(contentsOf: url as URL)
        
        
        let convertURL =  url as URL
        
        let fileData = try? Data.init(contentsOf: convertURL)
        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""
//
        AllUsersVM.shared.saveUserAttachment(imageId: userID, imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
            print("User attachment upload successfully")
//            uploadLatestID = String(attachIds)
            if (self.uploadAttachmentsArray == ""){
                self.uploadAttachmentsArray = String(attachIds)
            }
            else {
                self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
            }
            self.uploadAttachmentsArrayData.append(String(attachIds))
            self.uploadImageCollectionView.reloadData()
            self.hitProfileSave()
        }
    }

    
    // MARK:- Select Project Actions
    
    @IBAction func selectProjectBtnAction(_ sender: Any) {
        self.selectDocumentDropdown.show()
    }
    
    // MARK:- UIPikerview Create and Dismiss

//    func createPickerView() {
//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        if (nationalityTxt.tag == 101) {
//            nationalityTxt.inputView = pickerView
//        }
//        else {
//            employeeTypeTxt.inputView = pickerView
//        }
//    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: LocalizationKey.done.localizing(), style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        spokenLanguageTxt.inputAccessoryView = toolBar
    }

    @objc func doneClick() {
        if (selectedSpokenLanguage != nil) {
            let itemExists = checkItemInList(items: selectedSpokenLanguageListData, itemName: selectedSpokenLanguage ?? "")
            if itemExists {
                Toast.show(message: LocalizationKey.LanguageAllreadyAvailableInTheList.localizing(), controller: self)
            }
            else {
                selectedSpokenLanguageListData.append(selectedSpokenLanguage ?? "")
                print("selectedSpokenLanguageListData is : ", selectedSpokenLanguageListData)
                self.spokenLanguageCollectionView.reloadData()
            }
        }
        spokenLanguageTxt.resignFirstResponder()
    }
    
    // MARK:- Custom function for check validation

    func checkValidation() {
        guard fullnameTxt.text! != "" else{
            Toast.show(message: LocalizationKey.pleaseEnterName.localizing(), controller: self)
            return
        }
        guard emailTxt.text! != "" else{
            Toast.show(message: LocalizationKey.pleaseEnterEmail.localizing(), controller: self)
            return
        }
        guard phoneTxt.text! != "" else{
            Toast.show(message: LocalizationKey.pleaseEnterPhone.localizing(), controller: self)
            return
        }
    }
    
    // MARK:- Check data available function

    func checkItemInList(items : [String], itemName: String) -> Bool {
        let itemExists = items.contains(where: {
            $0.range(of: itemName, options: .caseInsensitive) != nil
        })
        return itemExists
    }
    
    // MARK:- Setup Assign project dropdown

    func selectAssignProjectDropDown() {
        assignProjectBtn.isEnabled = true
        assignProjectDropdown.anchorView = assignProjectBtn
        assignProjectDropdown.bottomOffset = CGPoint(x: 0, y: assignProjectDropdown.bounds.height)
        assignProjectDropdown.dataSource = assignProjectList
        assignProjectDropdown.cornerRad = 10
        assignProjectDropdown.selectedRowIndices = assignProjectsSelectedRowIndicesArray
        
        // Action triggered on selection
        assignProjectDropdown.multiSelectionAction = { [weak self] (index, item) in
            self?.selectedAssignProjectsListData.removeAll()
                self?.selectedAssignProjectsListData.append(contentsOf: item)
            DispatchQueue.main.async {
                self?.assignProjectsCollectionView.reloadData()
            }
        }
        assignProjectDropdown.dismissMode = .onTap
        assignProjectDropdown.backgroundColor = UIColor.white
//        assignProjectDropdown.selectionBackgroundColor = UIColor.systemPink
        // bithDateDropdown.shadow()
        assignProjectDropdown.direction = .bottom
    }
    
    // MARK:- Setup Select project dropdown

    func selectDocumentsDropdown() {
        selectProjectBtn.isEnabled = true
        selectDocumentDropdown.anchorView = selectProjectBtn
        selectDocumentDropdown.bottomOffset = CGPoint(x: 0, y: selectDocumentDropdown.bounds.height)
        selectDocumentDropdown.dataSource = selectDocumentList
        selectDocumentDropdown.cornerRad = 10
        
        // Action triggered on selection
        selectDocumentDropdown.multiSelectionAction = { [weak self] (index, item) in
            self?.selectedDocumentsListData.removeAll()
                self?.selectedDocumentsListData.append(contentsOf: item)
            DispatchQueue.main.async {
                self?.selectProjectCollectionView.reloadData()
            }
        }
        selectDocumentDropdown.dismissMode = .onTap
        selectDocumentDropdown.backgroundColor = UIColor.white
//        assignProjectDropdown.selectionBackgroundColor = UIColor.systemPink
        // bithDateDropdown.shadow()
        selectDocumentDropdown.direction = .bottom
    }
}


// MARK:- UICollectionView Delegate and DataSource

extension UserProfileDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == spokenLanguageCollectionView) {
            return selectedSpokenLanguageListData.count
        }
        else if (collectionView == equipmentCollectionView) {
            return equipmentListData.count
        }
        else if (collectionView == assignProjectsCollectionView) {
            return selectedAssignProjectsListData.count
        }
        else if (collectionView == selectProjectCollectionView) {
            return selectedDocumentsListData.count
        }
        else {
            return uploadAttachmentsArrayData.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if (collectionView == spokenLanguageCollectionView) {
            guard let selectedSpokenLanuageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.vbSpokenLanguageCollectionViewCell.rawValue, for: indexPath) as? SpokenLanguageCollectionViewCell else {
                return UICollectionViewCell()
            }
            selectedSpokenLanuageCollectionCell.languageNameLbl.text = selectedSpokenLanguageListData[indexPath.row]
            return selectedSpokenLanuageCollectionCell
        }
        else if (collectionView == equipmentCollectionView) {
            guard let selectedEquipmentCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.vbEquipmentCollectionViewCell.rawValue, for: indexPath) as? EquipmentCollectionViewCell else {
                return UICollectionViewCell()
            }
            selectedEquipmentCollectionCell.equipmentNameLbl.text = equipmentListData[indexPath.row]
            return selectedEquipmentCollectionCell
        }
        else if (collectionView == assignProjectsCollectionView) {
            guard let selectedAssignProjectsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.vbAssignProjectsCollectionViewCell.rawValue, for: indexPath) as? AssignProjectsCollectionViewCell else {
                return UICollectionViewCell()
            }
            selectedAssignProjectsCollectionCell.projectNameLbl.text = selectedAssignProjectsListData[indexPath.row]
            return selectedAssignProjectsCollectionCell
        }
        else if (collectionView == selectProjectCollectionView) {
            guard let selectedProjectsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.vbSelectProjectCollectionViewCell.rawValue, for: indexPath) as? SelectProjectCollectionViewCell else {
                return UICollectionViewCell()
            }
            selectedProjectsCollectionCell.selectedProjectLbl.text = selectedDocumentsListData[indexPath.row]
            return selectedProjectsCollectionCell
        }
        else {
            guard let selectedUploadImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.vbUploadImageCollectionViewCell.rawValue, for: indexPath) as? UploadImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            
//            let url = URL(string: API.SAVEATTACHMENT + "/\(uploadAttachmentsArrayData[indexPath.row].id ?? 0)")
            let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
            let url = URL(string: strUrl + "/\(uploadAttachmentsArrayData[indexPath.row])")
            selectedUploadImageCollectionCell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))

            return selectedUploadImageCollectionCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == spokenLanguageCollectionView) {
            if selectedSpokenLanguageListData.count > 1 {
                selectedSpokenLanguageListData.remove(at: indexPath.row)
                spokenLanguageCollectionView.reloadData()
            }
            else {
                Toast.show(message: LocalizationKey.notAllowedToDelete.localizing(), controller: self)
            }
        }
        else if (collectionView == equipmentCollectionView) {
            if equipmentListData.count > 1 {
                equipmentListData.remove(at: indexPath.row)
                equipmentCollectionView.reloadData()
            }
            else {
                Toast.show(message: LocalizationKey.notAllowedToDelete.localizing(), controller: self)
            }
        }
        else if (collectionView == assignProjectsCollectionView) {
            //            if selectedAssignProjectsListData.count > 1 {
            selectedAssignProjectsListData.remove(at: indexPath.row)
//            assignProjectsSelectedRowIndicesArray.remove(at: indexPath.row)
            assignProjectsCollectionView.reloadData()
//            selectAssignProjectDropDown()
            //            }
            //            else {
            //                Toast.show(message: "Not allowed to delete", controller: self)
            //            }
        }
        else if (collectionView == selectProjectCollectionView) {
//            if selectedDocumentsListData.count > 1 {
                selectedDocumentsListData.remove(at: indexPath.row)
                selectProjectCollectionView.reloadData()
//            }
//            else {
//                Toast.show(message: "Not allowed to delete", controller: self)
//            }
        }
    }
}

// MARK:- UIPikerview Delegate and DataSource

extension UserProfileDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 101) {
            return NationalityList.count
        }
        else if (pickerView.tag == 102) {
            return EmploymentTypeList.count
        }
        else {
            return SpokenLanguageList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 101) {
            return NationalityList[row]
        }
        else if (pickerView.tag == 102) {
            return EmploymentTypeList[row]
        }
        else {
            return SpokenLanguageList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 101) {
            nationalityTxt.text = NationalityList[row]
        }
        else if (pickerView.tag == 102) {
            employeeTypeTxt.text = EmploymentTypeList[row]
        }
        else {
            selectedSpokenLanguage = SpokenLanguageList[row]
        }
    }
}

extension UserProfileDetailsVC: UITextFieldDelegate  {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.tag == 101 || textField.tag == 102 || textField.tag == 103) {
            textField.inputView = pickerView
            pickerView.tag =  textField.tag
        }
        return true;
    }
}

//MARK: User Details Api's

extension UserProfileDetailsVC {
        
    func hitGetUsersDetailsApi(id: String) -> Void {
        var param = [String:Any]()
        AllUsersVM.shared.getUsersDetailsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            print("User Details is : ", obj)
            userProfileData = obj.user!
            // User image set
            self.userImageID =  obj.user?.image ?? ""
            let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
            let url = URL(string: strUrl + "/\(obj.user?.image ?? "")")
            self.userImage.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            self.userImage.contentMode = .scaleAspectFill

            // Deactive user
            if (obj.user?.status == "active")  {
                self.activeDeactiveSwitch.isOn = true
                strDeactiveUser = "active"
            }
            else {
                self.activeDeactiveSwitch.isOn = false
                strDeactiveUser = "deactive"
            }
            
            self.fullnameTxt.text = (obj.user?.first_name ?? "") + " " + (obj.user?.last_name ?? "")
            self.emailTxt.text = obj.user?.email ?? ""
            self.phoneTxt.text = obj.user?.phone
            self.dateOfBirthTxt.text = obj.user?.birthday
            self.ssmTxt.text = obj.user?.social_number
//            self.nationalityTxt.text = obj.user?.nationality
            //Gender
            self.employeeTypeTxt.text = obj.user?.employee_type
            // Spoken language

            self.fullAddressTxt.text = obj.user?.address
            self.zipCodeTxt.text = obj.user?.post_number
            self.cityTxt.text = obj.user?.post_place
            
            self.userNameTxt.text = obj.user?.username
            self.userRoleTxt.text = obj.user?.user_type
            self.employeeIDTxt.text = "\(obj.user?.internal_number ?? 0)"
//            self.passwordTxt.text = obj.user?.password
            self.pinTxt.text = obj.user?.generic_pin
            self.numberOfHolidaysTxt.text = String(obj.user?.vacation_days ?? 0)
            // Equipment

            // Disable auto log
            self.disableLogsSwitch.setOn(obj.user?.disable_autolog ?? false, animated: true)
            
            self.grossRateTxt.text = obj.user?.payment_mode
            self.hourlyRateTxt.text = String(obj.user?.hourly_rate ?? 0)
            self.startDateTxt.text = obj.user?.timelog_start_from
//            self.workHoursTxt.text = obj.user?.work_hour
//            self.numberOfHolidayTxt = obj.user?.number_holiday
            // Assign projects
            
//            self.bankNameTxt.text = obj.user?.bank_name
//            self.accountHolderNameTxt.text = obj.user?.account_holder_name
//            self.accountNumberTxt.text = obj.user?.account_number
            
//            self.aboutLbl.text = obj.user?.about
//            self.aboutTv.text = obj.user?.about

            // Documents and Attachments
            attachmentArray = obj.user?.attachmentsData ?? []
            for i in 0 ..< attachmentArray.count {
                if (uploadAttachmentsArray == ""){
                    uploadAttachmentsArray = String(attachmentArray[i].id ?? 0)
                }
                else {
                    uploadAttachmentsArray = uploadAttachmentsArray + "," + String(attachmentArray[i].id ?? 0)
                }
                uploadAttachmentsArrayData.append(String(attachmentArray[i].id ?? 0))
            }
                    
            self.uploadImageCollectionView.reloadData()
            // Select Project
            self.hitGetManageProjectsList(manageProjects: obj.user?.memberInProjects ?? "")
        }
    }
    
    func hitGetManageProjectsList(manageProjects : String) -> Void {
        var param = [String:Any]()
        AllUsersVM.shared.getMangeProjectsAPI(parameters: param, isAuthorization: true) { [self] obj in
            let arrAssignProjects = manageProjects.components(separatedBy: ",")
            arrManageProjectList = obj
            for i in 0 ..< obj.count {
                assignProjectList.append(obj[i].fullname ?? "" )
                for j in 0 ..< arrAssignProjects.count {
                    if (String(obj[i].id ?? 0) == arrAssignProjects[j]) {
                        self.selectedAssignProjectsListData.append(obj[i].fullname ?? "")
                        self.assignProjectsSelectedRowIndicesArray.insert(i)
                    }
                }
            }
            self.selectAssignProjectDropDown()
            self.assignProjectsCollectionView.reloadData()
            self.hitGetDocumentsTemplatesList()
        }
    }
    
    func hitGetDocumentsTemplatesList() -> Void {
        var param = [String:Any]()
        AllUsersVM.shared.getDocumentsTemplatesAPI(parameters: param, id: "2198", isAuthorization: true) { [self] obj in
            self.arrDocumentsList = obj.document_templates!
            for i in 0 ..< (arrDocumentsList .count) {
                selectDocumentList.append(arrDocumentsList[i].template_name ?? "" )
//                for j in 0 ..< arrAssignProjects.count {
//                    if (String(obj[i].id ?? 0) == arrAssignProjects[j]) {
//                        self.selectedAssignProjectsListData.append(obj[i].fullname ?? "")
//                        self.assignProjectsSelectedRowIndicesArray.insert(i)
//                    }
//                }
            }
            self.selectDocumentsDropdown()
            self.selectProjectCollectionView.reloadData()
        }
    }
    
    func hitProfileSave() -> Void {
        var memberInProjects = ""
        for i in 0 ..< arrManageProjectList.count {
            for j in 0 ..< selectedAssignProjectsListData.count {
                if (String(arrManageProjectList[i].fullname ?? "") == selectedAssignProjectsListData[j]) {
                    if (memberInProjects == ""){
                        memberInProjects = String(arrManageProjectList[i].id ?? 0)
                    }
                    else {
                        memberInProjects = memberInProjects + "," + String(arrManageProjectList[i].id ?? 0)
                    }
                }
            }
        }
        var dataParam = [String:Any]()

        dataParam["MemberInProjects"] = memberInProjects
        dataParam["attachments"] = uploadAttachmentsArray
        dataParam["birthday"] = self.dateOfBirthTxt.text
        dataParam["client_id"] = userProfileData?.client_id
//        dataParam["data"] = userProfileData?.data
        dataParam["disable_autolog"] = strDisableLog
        dataParam["email"] = self.emailTxt.text
        dataParam["employee_percent"] = userProfileData?.employee_percent
        dataParam["first_name"] = userProfileData?.first_name
        dataParam["generic_pin"] = self.pinTxt.text
        dataParam["hourly_rate"] = self.hourlyRateTxt.text?.intValue()
        dataParam["id"] = userProfileData?.id
        dataParam["image"] = self.userImageID
        dataParam["last_name"] = userProfileData?.last_name
        dataParam["payment_mode"] = self.grossRateTxt.text
        dataParam["phone"] = self.phoneTxt.text
        dataParam["status"] = strDeactiveUser
        dataParam["timelog_start_from"] = self.startDateTxt.text
        dataParam["user_type"] = userProfileData?.user_type
        dataParam["username"] = userProfileData?.username
        dataParam["vacation_days"] = self.numberOfHolidaysTxt.text?.intValue()
        print(dataParam)
        AllUsersVM.shared.saveUserProfileDetailsApi(parameters: dataParam, id: userID, isAuthorization: true) { [self] obj in
            
            print(obj)
//            self.hitGetUsersDetailsApi(id: userID)
        }
    }
}

