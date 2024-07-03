
import UIKit

protocol DeviationProjectTVCDelegate: AnyObject {
    func onTextViewDidEndEditingData(textViewData: String, textViewType: String)
}

class DeviationProjectTVC: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var selectedProjectView: UIView!
    @IBOutlet weak var selectedProjectLbl: UILabel!
    @IBOutlet weak var selectedProjectLocationLbl: UILabel!
    @IBOutlet weak var btnProjectName: UIButton!
    
    @IBOutlet weak var selectedTaskView: UIView!
    @IBOutlet weak var selectedTaskLbl: UILabel!
    @IBOutlet weak var selectedTaskLocationLbl: UILabel!
    @IBOutlet weak var btnTaskName: UIButton!

    @IBOutlet weak var subjectTxt: UITextField!
    @IBOutlet weak var deviationDetailsTxtVw: UITextView!
    
    @IBOutlet weak var projectVw: UIView!
    @IBOutlet weak var taskVw: UIView!
    @IBOutlet weak var subjectVw: UIView!
    @IBOutlet weak var detailsVw: UIView!
    
    weak var delegate : DeviationProjectTVCDelegate?
    @IBOutlet weak var projectSelectedLbl: UILabel!
    @IBOutlet weak var selectTaskLbl: UILabel!
    @IBOutlet weak var taskSelectedLbl: UILabel!
    @IBOutlet weak var staticSubjectLbl: UILabel!
    @IBOutlet weak var staticDeviationDetailsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblProjectName.text = LocalizationKey.selectProject.localizing()
        projectSelectedLbl.text = LocalizationKey.selected.localizing()
        taskSelectedLbl.text = LocalizationKey.selected.localizing()
        selectTaskLbl.text = LocalizationKey.selectTask.localizing()
        staticSubjectLbl.text = LocalizationKey.subject.localizing()
        subjectTxt.text = LocalizationKey.subject.localizing()
        staticDeviationDetailsLbl.text = LocalizationKey.deviationDetails.localizing()
        
        subjectTxt.delegate = self
        deviationDetailsTxtVw.delegate = self
//        configUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(deviationsDetailsData : DeviationDetails?, projectID: String, projectName: String, taskID: String, taskName: String) -> Void {
        subjectVw.isHidden = false
        detailsVw.isHidden = false
        projectVw.isHidden = false
        taskVw.isHidden = false
        
        if projectID != "" {
            selectedProjectView.isHidden = false
            selectedProjectLbl.text = "\(projectID) | \(projectName)"
            selectedProjectLocationLbl.text = LocalizationKey.missing.localizing()
        } else {
            selectedProjectView.isHidden = true
        }
        
        if taskID != "" {
            selectedTaskView.isHidden = false
            selectedTaskLbl.text = "\(taskID) | \(taskName)"
            selectedTaskLocationLbl.text = LocalizationKey.missing.localizing()
        } else {
            selectedTaskView.isHidden = true
        }
        
        subjectTxt.text = deviationsDetailsData?.subject
        deviationDetailsTxtVw.text = deviationsDetailsData?.comments
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "comments")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.onTextViewDidEndEditingData(textViewData: textField.text ?? "", textViewType: "subject")
    }
}
