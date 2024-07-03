//
//  PayrollReportVC.swift
//  TimeControllApp
//
//  Created by mukesh on 12/07/22.
//

import UIKit

class PayrollReportVC: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toDateTxtField: UITextField!
    @IBOutlet weak var fromDateTxtField: UITextField!
    @IBOutlet weak var datePickerVw: UIView!
    
    @IBOutlet weak var payrollReportLbl: UILabel!
    var selectedDate = ""
    @IBOutlet weak var staticSendToThisEmailLbl: UILabel!
    @IBOutlet weak var staticFromLbl: UILabel!
    @IBOutlet weak var staticToLbl: UILabel!
    @IBOutlet weak var sendBtnObj: UIButton!
    @IBOutlet weak var previewBtnObj: UIButton!
    @IBOutlet weak var doneBtnObj: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        datePickerVw.isHidden = true

        //MARK: Change the date formate from configuration
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format
        fromDateTxtField.text = dateFormatter.string(from: Date())
        toDateTxtField.text = dateFormatter.string(from: Date())
    }
    
    func setUpLocalization() {
        payrollReportLbl.text = LocalizationKey.payrollReport.localizing()
        staticSendToThisEmailLbl.text = LocalizationKey.sendToThisEmail.localizing()
        staticFromLbl.text = LocalizationKey.from.localizing()
        staticToLbl.text = LocalizationKey.to.localizing()
        sendBtnObj.setTitle(LocalizationKey.send.localizing(), for: .normal)
        previewBtnObj.setTitle(LocalizationKey.preview.localizing(), for: .normal)
        doneBtnObj.setTitle(LocalizationKey.done.localizing(), for: .normal)
    }
    
    
    func chooseDate(){
        let dateFormatter = DateFormatter()
        
        //MARK: Change the date formate from configuration
//        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format
        
        let chooseDate = dateFormatter.string(from: datePicker.date)
        
        if selectedDate == "fromDate" {
            fromDateTxtField.text = chooseDate
        } else {
            toDateTxtField.text = chooseDate
        }
        datePickerVw.isHidden = true
    }
    
    @IBAction func fromDatePickerBtnAction(_ sender: Any) {
        selectedDate = "fromDate"
        datePickerVw.isHidden = false
    }
    
    @IBAction func toDatePicketBtnAction(_ sender: Any) {
        selectedDate = "toDate"
        datePickerVw.isHidden = false
    }
    
    
    @IBAction func doneBtnAction(_ sender: Any) {
        chooseDate()
    }
    
}
