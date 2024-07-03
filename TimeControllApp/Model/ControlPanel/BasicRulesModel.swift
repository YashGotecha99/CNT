//
//  BasicRulesModel.swift
//  TimeControllApp
//
//  Created by prashant on 24/04/23.
//

import Foundation

struct BasicRulesModel : Codable {
    var overtime_types : [Overtime_types]?
    let startTimeRules : StartTimeRules?
    let breakTimeRules : BreakTimeRules?
    let allowQucikChecklist : Bool?
    let allowManualTimelogChange : Bool?
    let allow_overtime_limit : Bool?
    let displayCommentAfterFinish : Bool?
    let signatureModalAfterWorklog : Bool?
    let workinghourUserphoto : Bool?
    let workinghourGPSObligatory : Bool?
    let pmManagesOvertime : Bool?
    let worklogValidation : WorklogValidation?
    let allowSingleParentCare : Bool?
    let quickCheckListText : String?
    let maxAllowedTimePeriodToLogOutWithGPSObligatory : Int?
    let allowWeeklyManualOvertimeRegister : Bool?
    let maxWeeklyWorkingHours : Int?
    let hideBreakButton : Bool?
    let overtimeAutomaticMode : Bool?
    let overtimeCalcRules : OvertimeCalcRules?
    let weekStartDay : Int?
    let messageSetting : String?
    let allowAvailability : Bool?
    let allowAutoStatusAvailability : Bool?
    let disableDeleteTimelogWhenApproved : Bool?
    let showAbsenceAndVacationInMobile : Bool?

    enum CodingKeys: String, CodingKey {

        case overtime_types = "overtime_types"
        case startTimeRules = "startTimeRules"
        case breakTimeRules = "breakTimeRules"
        case allowQucikChecklist = "allowQucikChecklist"
        case allowManualTimelogChange = "allowManualTimelogChange"
        case allow_overtime_limit = "allow_overtime_limit"
        case displayCommentAfterFinish = "displayCommentAfterFinish"
        case signatureModalAfterWorklog = "signatureModalAfterWorklog"
        case workinghourUserphoto = "workinghourUserphoto"
        case workinghourGPSObligatory = "workinghourGPSObligatory"
        case pmManagesOvertime = "pmManagesOvertime"
        case worklogValidation = "worklogValidation"
        case allowSingleParentCare = "allowSingleParentCare"
        case quickCheckListText = "quickCheckListText"
        case maxAllowedTimePeriodToLogOutWithGPSObligatory = "maxAllowedTimePeriodToLogOutWithGPSObligatory"
        case allowWeeklyManualOvertimeRegister = "allowWeeklyManualOvertimeRegister"
        case maxWeeklyWorkingHours = "maxWeeklyWorkingHours"
        case hideBreakButton = "hideBreakButton"
        case overtimeAutomaticMode = "overtimeAutomaticMode"
        case overtimeCalcRules = "overtimeCalcRules"
        case weekStartDay = "weekStartDay"
        case messageSetting = "messageSetting"
        case allowAvailability = "allowAvailability"
        case allowAutoStatusAvailability = "allowAutoStatusAvailability"
        case disableDeleteTimelogWhenApproved = "disableDeleteTimelogWhenApproved"
        case showAbsenceAndVacationInMobile = "showAbsenceAndVacationInMobile"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        overtime_types = try values.decodeIfPresent([Overtime_types].self, forKey: .overtime_types)
        startTimeRules = try values.decodeIfPresent(StartTimeRules.self, forKey: .startTimeRules)
        breakTimeRules = try values.decodeIfPresent(BreakTimeRules.self, forKey: .breakTimeRules)
        allowQucikChecklist = try values.decodeIfPresent(Bool.self, forKey: .allowQucikChecklist)
        allowManualTimelogChange = try values.decodeIfPresent(Bool.self, forKey: .allowManualTimelogChange)
        allow_overtime_limit = try values.decodeIfPresent(Bool.self, forKey: .allow_overtime_limit)
        displayCommentAfterFinish = try values.decodeIfPresent(Bool.self, forKey: .displayCommentAfterFinish)
        signatureModalAfterWorklog = try values.decodeIfPresent(Bool.self, forKey: .signatureModalAfterWorklog)
        workinghourUserphoto = try values.decodeIfPresent(Bool.self, forKey: .workinghourUserphoto)
        workinghourGPSObligatory = try values.decodeIfPresent(Bool.self, forKey: .workinghourGPSObligatory)
        pmManagesOvertime = try values.decodeIfPresent(Bool.self, forKey: .pmManagesOvertime)
        worklogValidation = try values.decodeIfPresent(WorklogValidation.self, forKey: .worklogValidation)
        allowSingleParentCare = try values.decodeIfPresent(Bool.self, forKey: .allowSingleParentCare)
        quickCheckListText = try values.decodeIfPresent(String.self, forKey: .quickCheckListText)
        maxAllowedTimePeriodToLogOutWithGPSObligatory = try values.decodeIfPresent(Int.self, forKey: .maxAllowedTimePeriodToLogOutWithGPSObligatory)
        allowWeeklyManualOvertimeRegister = try values.decodeIfPresent(Bool.self, forKey: .allowWeeklyManualOvertimeRegister)
        maxWeeklyWorkingHours = try values.decodeIfPresent(Int.self, forKey: .maxWeeklyWorkingHours)
        hideBreakButton = try values.decodeIfPresent(Bool.self, forKey: .hideBreakButton)
        overtimeAutomaticMode = try values.decodeIfPresent(Bool.self, forKey: .overtimeAutomaticMode)
        overtimeCalcRules = try values.decodeIfPresent(OvertimeCalcRules.self, forKey: .overtimeCalcRules)
        weekStartDay = try values.decodeIfPresent(Int.self, forKey: .weekStartDay)
        messageSetting = try values.decodeIfPresent(String.self, forKey: .messageSetting)
        allowAvailability = try values.decodeIfPresent(Bool.self, forKey: .allowAvailability)
        allowAutoStatusAvailability = try values.decodeIfPresent(Bool.self, forKey: .allowAutoStatusAvailability)
        disableDeleteTimelogWhenApproved = try values.decodeIfPresent(Bool.self, forKey: .disableDeleteTimelogWhenApproved)
        showAbsenceAndVacationInMobile = try values.decodeIfPresent(Bool.self, forKey: .showAbsenceAndVacationInMobile)
    }

}

struct Overtime_types : Codable {
    var code : String?
    var multiplier : Int?
    var name : String?
    var value : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case multiplier = "multiplier"
        case name = "name"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        multiplier = try values.decodeIfPresent(Int.self, forKey: .multiplier)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}

struct StartTimeRules : Codable {
    let start : String?
    let end : String?
    let total : String?

    enum CodingKeys: String, CodingKey {

        case start = "start"
        case end = "end"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(String.self, forKey: .start)
        end = try values.decodeIfPresent(String.self, forKey: .end)
        total = try values.decodeIfPresent(String.self, forKey: .total)
    }

}

struct BreakTimeRules : Codable {
    let minutes : String?

    enum CodingKeys: String, CodingKey {

        case minutes = "minutes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        minutes = try values.decodeIfPresent(String.self, forKey: .minutes)
    }

}

struct WorklogValidation : Codable {
    let criticalVarianceThreshold : String?
    let overtimeThreshold : String?
    let sendEmailNotificationAt : String?
    let sendEmailNotificationForCriticalThresholdToAdmin : Bool?
    let sendEmailNotificationForCriticalThresholdToPM : Bool?
    let sendEmailNotificationForMediumThresholdToAdmin : Bool?
    let sendEmailNotificationForMediumThresholdToPM : Bool?
    let sendEmailNotificationForOvertimeThresholdToAdmin : Bool?
    let sendEmailNotificationForOvertimeThresholdToPM : Bool?
    let validateTimetrackOption : Bool?

    enum CodingKeys: String, CodingKey {

        case criticalVarianceThreshold = "criticalVarianceThreshold"
        case overtimeThreshold = "overtimeThreshold"
        case sendEmailNotificationAt = "sendEmailNotificationAt"
        case sendEmailNotificationForCriticalThresholdToAdmin = "sendEmailNotificationForCriticalThresholdToAdmin"
        case sendEmailNotificationForCriticalThresholdToPM = "sendEmailNotificationForCriticalThresholdToPM"
        case sendEmailNotificationForMediumThresholdToAdmin = "sendEmailNotificationForMediumThresholdToAdmin"
        case sendEmailNotificationForMediumThresholdToPM = "sendEmailNotificationForMediumThresholdToPM"
        case sendEmailNotificationForOvertimeThresholdToAdmin = "sendEmailNotificationForOvertimeThresholdToAdmin"
        case sendEmailNotificationForOvertimeThresholdToPM = "sendEmailNotificationForOvertimeThresholdToPM"
        case validateTimetrackOption = "validateTimetrackOption"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        criticalVarianceThreshold = try values.decodeIfPresent(String.self, forKey: .criticalVarianceThreshold)
        overtimeThreshold = try values.decodeIfPresent(String.self, forKey: .overtimeThreshold)
        sendEmailNotificationAt = try values.decodeIfPresent(String.self, forKey: .sendEmailNotificationAt)
        sendEmailNotificationForCriticalThresholdToAdmin = try values.decodeIfPresent(Bool.self, forKey: .sendEmailNotificationForCriticalThresholdToAdmin)
        sendEmailNotificationForCriticalThresholdToPM = try values.decodeIfPresent(Bool.self, forKey: .sendEmailNotificationForCriticalThresholdToPM)
        sendEmailNotificationForMediumThresholdToAdmin = try values.decodeIfPresent(Bool.self, forKey: .sendEmailNotificationForMediumThresholdToAdmin)
        sendEmailNotificationForMediumThresholdToPM = try values.decodeIfPresent(Bool.self, forKey: .sendEmailNotificationForMediumThresholdToPM)
        sendEmailNotificationForOvertimeThresholdToAdmin = try values.decodeIfPresent(Bool.self, forKey: .sendEmailNotificationForOvertimeThresholdToAdmin)
        sendEmailNotificationForOvertimeThresholdToPM = try values.decodeIfPresent(Bool.self, forKey: .sendEmailNotificationForOvertimeThresholdToPM)
        validateTimetrackOption = try values.decodeIfPresent(Bool.self, forKey: .validateTimetrackOption)
    }

}

struct OvertimeCalcRules : Codable {
    let calc_percent : Int?
    let calc_period : String?
    let max_hours : Int?
//    let max_minutes : String?
    let weekend_days : String?
    let weekend_percent : Int?

    enum CodingKeys: String, CodingKey {

        case calc_percent = "calc_percent"
        case calc_period = "calc_period"
        case max_hours = "max_hours"
//        case max_minutes = "max_minutes"
        case weekend_days = "weekend_days"
        case weekend_percent = "weekend_percent"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        calc_percent = try values.decodeIfPresent(Int.self, forKey: .calc_percent)
        calc_period = try values.decodeIfPresent(String.self, forKey: .calc_period)
        max_hours = try values.decodeIfPresent(Int.self, forKey: .max_hours)
//        max_minutes = try values.decodeIfPresent(String.self, forKey: .max_minutes)
        weekend_days = try values.decodeIfPresent(String.self, forKey: .weekend_days)
        weekend_percent = try values.decodeIfPresent(Int.self, forKey: .weekend_percent)
    }

}
