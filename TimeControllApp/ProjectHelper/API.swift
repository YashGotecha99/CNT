//
//  API.swift
//  TimeControllApp
//
//  Created by mukesh on 11/08/22.
//

import Foundation
import UIKit

//class API {
//
//    static let BASE_URL = "https://tidogkontroll.no/api/"
////    static let BASE_URL = "http://172.18.5.222:3000/api/"
//
////    static let BASE_URL = "https://norsktimeregister.no/api/"
//
////    static let LOGIN = API.BASE_URL+"users/login"
////    static let FORGOTPASSWORD = API.BASE_URL+"users/verify_email"
////    static let VERIFYOTP = API.BASE_URL+"users/verify_email_otp"
////    static let RESETPASSWORD = API.BASE_URL+"users/reset_password"
////
////
////    static let LOADUSERCONFIG = API.BASE_URL+"user/loadUserConfig"
//////    static let DASHBOARD = API.BASE_URL+"dashboard/dashboard-v1"
////    static let DASHBOARD = API.BASE_URL+"dashboard"
////
////    static let timelogs = API.BASE_URL+"timelogs"
////
////    static let SCHEDULE = API.BASE_URL + "schedule"
////    static let SAVEATTACHMENT = API.BASE_URL+"attachments"
//
//    static let LOGIN = GlobleVariables.dynamicBaseUrl+"users/login"
//    static let FORGOTPASSWORD = GlobleVariables.dynamicBaseUrl+"users/verify_email"
//    static let VERIFYOTP = GlobleVariables.dynamicBaseUrl+"users/verify_email_otp"
//    static let RESETPASSWORD = GlobleVariables.dynamicBaseUrl+"users/reset_password"
//
//    static let LOADUSERCONFIG = GlobleVariables.dynamicBaseUrl+"user/loadUserConfig"
////    static let DASHBOARD = GlobleVariables.dynamicBaseUrl+"dashboard/dashboard-v1"
//    static let DASHBOARD = GlobleVariables.dynamicBaseUrl+"dashboard"
//
//    static let timelogs = GlobleVariables.dynamicBaseUrl+"timelogs"
//
//    static let SCHEDULE = GlobleVariables.dynamicBaseUrl + "schedule"
//    static let SAVEATTACHMENT = GlobleVariables.dynamicBaseUrl+"attachments"
//}



struct endPointURL {
    
    
    static let LOGIN = "users/login"
    static let FORGOTPASSWORD = "users/verify_email"
    static let VERIFYOTP = "users/verify_email_otp"
    static let RESETPASSWORD = "users/reset_password"
    
    static let LOADUSERCONFIG = "user/loadUserConfig"
    static let DASHBOARD = "dashboard"
    
    static let timelogs = "v2/timelogs"
    
    static let SCHEDULE = "schedule"
    static let SAVEATTACHMENT = "attachments"
    
    
  //  static let projects            = "projects/lookup_projects"
    static let tasks               = "tasks"
    static let addTask             =  "tasks/"
    static let projects               = "projects"
//    static let projects               = "projects/lookup_projects?mode=all&module=no-module"
    
    static let draftid               = "timelogs/draft_id"
    static let timelogsstart        = "timelogs/start"
    static let timelogsfinish        = "timelogs/finish"
    static let timelogsbreak        = "timelogs/break"
    
    static let usersList        = "admins"
    static let manageProjectList        = "projects/lookup_projects"
    static let documentsTemplatesList        = "document_templates/getTemplateAssignList"
    static let userByProject = "user/byprojectid"

    
    
    //Vacation and abseance
    static let vacationList =  "vacations"
    static let absencesList =  "absences"
    static let pendingRequestList = "absences/pending_absences_and_vacations"
    
    //Approve and Reject
    static let approveOrRejectVacation = "timelogs/status/vacation"
    static let approveOrRejectAbsence = "timelogs/status/absence"
    
    //CheckList
    static let checkList = "userchecklists"
    static let checkListDetails = "userchecklists/get"
    static let checkListCheck = "userchecklists/check"
    static let checkListApprove = "userchecklists/approve"
    static let userCheckList = "checklists/lookup_checklist"
    static let addCheckList = "userchecklists/assign"
    static let checkAll = "userchecklists/checkall"
    
    
    //Schedule
    static let scheduleList = "schedule/mobile"
    static let shiftListByUser =  "schedule/shift_info"
    static let sendRequestForTrade = "schedule/send_trade_request"
    static let swapShiftRequests = "schedule/swap_shift_requests"
    static let swapAccepted = "schedule/swap_accepted"
    static let swapRejected = "schedule/swap_rejected"
    static let swapShiftRequestsForPm = "schedule/swap_shift_requests_approval"
    static let swapAcceptedRejectedByPm = "schedule/shift_swap_approve_or_reject"
    static let tradeAcceptedRejectedByPm = "schedule/shift_trade_approve_or_reject"
    static let sendswaprequest = "schedule/send_swap_request"
    static let getAllCount = "schedule/getAllCount"
    
    static let currentDraftOrSkip = "v2/timelogs/current_draft_or_skip"
    static let saveWorkHours = "v2/timelogs"
    static let finishWorkHours = "v2/timelogs/finish"
    static let breakResumeWorkHours = "v2/timelogs/break"
    static let approveRejectWorkHours = "v2/timelogs/status/timelog"
    static let validateTimelogWithIntegration = "timelogs/validateTimelogWithIntegration"
    // Injury Work Hours
    static let setInjury = "v2/timelogs/reportInjury"

    
    // Schedule
    static let scheduleFilterList = "schedule"
    static let copyWeek = "schedule/copy_to_next"
    static let createShift = "schedule/"
    
    // Availability

    static let getAvailability = "availability/get-table"
    static let getAvailabilityByID = "availability/"
    static let createAvailability = "availability"
    
    static let getDeviations = "deviations"
    
    static let getLopkupTasks = "tasks/lookup_tasks"
    
    static let assignMember = "/transition/assign"
    static let unAssignMember = "/transition/unassign"
    static let reAssignMember = "/transition/reassign"
    
    static let checklistDeviation = "/userchecklists/deviation"
    
    //Chat
    static let getRooms = "/chat/rooms"
    static let getPrivateRooms = "/chat/privaterooms"
    static let getMembers = "/admins/lookup_users"
    static let getRoomMessages = "chat/room"
    static let getRoomPrivateMessages = "chat/privateroom"
    static let deleteChat = "chat"
    static let swapEmployees = "schedule"

    
    // Configuration for control panel
    static let getControlPanelConfiguration = "config"
    
    // Dashboard
    static let getDashbaord = "dashboard"

    // FCM Token
    static let fcmToken = "user/fcm_pustoken"
    
    // Notification
    static let notification = "user/notifications"
    static let clearNotification = "user/clear-notifications"
    static let readNotification = "user/notifications-read"
    
    // GPS Location
    static let gpsLocation = "tasks/geolocation?"
    static let saveGpsLocation = "admins"
    static let getHomeLocation = "user"
    
    //Document
    static let documentList = "document_templates"
    static let documentPreview = "document_templates/reportPreview"
    static let obligatedDocumentList = "document_read/obligatedDocs"
    
    //Language
    static let language = "user/lang"
    
    //Report
    static let sendReport = "dashboard/send_report"
    static let confirmTheDocument = "document_read/edit"
    
    //Vacations User data
    static let vacationUserData = "user"
    
    // My Files
    static let myFilesData = "admins/attachments-mimic-extradoc-list"
    static let myContractData = "extradocs"
    static let myFilesByIdData = "api/admins/attachments-mimic-extradoc-item"
    static let myFilesdelete = "attachments-mimic-extradoc-delete"
    static let locales = "locales/"
    static let translation = "/translation.json"
}

struct Constant {

    static let googleKey = "AIzaSyD_d0DkNLNnnUBZL9hYnUErCvcXKs9qwUo"
    
    static let appColor = "2550AC".hexStringToUIColor()
    
}
