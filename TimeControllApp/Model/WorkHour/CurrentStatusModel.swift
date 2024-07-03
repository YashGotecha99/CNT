//
//  CurrentStatusModel.swift
//  TimeControllApp
//
//  Created by prashant on 06/03/23.
//

import Foundation

struct CurrentStatusModel : Codable {
    let timelog : CurrentTimelog?
    
    enum CodingKeys: String, CodingKey {
        case timelog = "timelog"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timelog = try values.decodeIfPresent(CurrentTimelog.self, forKey: .timelog)
    }
}


struct CurrentTimelog : Codable {
    let id : Int?
    let status : String?
    let client_id : Int?
    let user_id : Int?
    let task_id : Int?
    let for_date : String?
    let from : Int?
    let to : Int?
//    let is_holiday : String?
    let total_hours_normal : Int?
    let total_hours_overtime : Int?
    let breakTime : Int?
    let comments : String?
    let description : String?
    var data : TimelogData?
    let created_at : String?
    let updated_at : String?
    let actual_added_by : String?
    let status_note : String?
    let status_changed_by : String?
    let status_changed_on : String?
    let gps_status : String?
    let gps_start_data : String?
    let gps_end_data : String?
    let gps_data : CurrentGpsData?
    let tracker_running : Bool?
    let tracker_status : String?
    let paid_hours : String?
    let location_string : String?
    let user_image_attachment_id : String?
    let tip_id : String?
    let auto_logout : Bool?
    let admin_note : String?
    let task_name : String?
    let anomaly : Anomaly?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case client_id = "client_id"
        case user_id = "user_id"
        case task_id = "task_id"
        case for_date = "for_date"
        case from = "from"
        case to = "to"
//        case is_holiday = "is_holiday"
        case total_hours_normal = "total_hours_normal"
        case total_hours_overtime = "total_hours_overtime"
        case breakTime = "break"
        case comments = "comments"
        case description = "description"
        case data = "data"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case actual_added_by = "actual_added_by"
        case status_note = "status_note"
        case status_changed_by = "status_changed_by"
        case status_changed_on = "status_changed_on"
        case gps_status = "gps_status"
        case gps_start_data = "gps_start_data"
        case gps_end_data = "gps_end_data"
        case gps_data = "gps_data"
        case tracker_running = "tracker_running"
        case tracker_status = "tracker_status"
        case paid_hours = "paid_hours"
        case location_string = "location_string"
        case user_image_attachment_id = "user_image_attachment_id"
        case tip_id = "tip_id"
        case auto_logout = "auto_logout"
        case admin_note = "admin_note"
        case task_name = "task_name"
        case anomaly = "anomaly"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
//        is_holiday = try values.decodeIfPresent(String.self, forKey: .is_holiday)
        total_hours_normal = try values.decodeIfPresent(Int.self, forKey: .total_hours_normal)
        total_hours_overtime = try values.decodeIfPresent(Int.self, forKey: .total_hours_overtime)
        breakTime = try values.decodeIfPresent(Int.self, forKey: .breakTime)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        data = try values.decodeIfPresent(TimelogData.self, forKey: .data)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        actual_added_by = try values.decodeIfPresent(String.self, forKey: .actual_added_by)
        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
        status_changed_by = try values.decodeIfPresent(String.self, forKey: .status_changed_by)
        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
        gps_status = try values.decodeIfPresent(String.self, forKey: .gps_status)
        gps_start_data = try values.decodeIfPresent(String.self, forKey: .gps_start_data)
        gps_end_data = try values.decodeIfPresent(String.self, forKey: .gps_end_data)
        gps_data = try values.decodeIfPresent(CurrentGpsData.self, forKey: .gps_data)
        tracker_running = try values.decodeIfPresent(Bool.self, forKey: .tracker_running)
        tracker_status = try values.decodeIfPresent(String.self, forKey: .tracker_status)
        paid_hours = try values.decodeIfPresent(String.self, forKey: .paid_hours)
        location_string = try values.decodeIfPresent(String.self, forKey: .location_string)
        user_image_attachment_id = try values.decodeIfPresent(String.self, forKey: .user_image_attachment_id)
        tip_id = try values.decodeIfPresent(String.self, forKey: .tip_id)
        auto_logout = try values.decodeIfPresent(Bool.self, forKey: .auto_logout)
        admin_note = try values.decodeIfPresent(String.self, forKey: .admin_note)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        anomaly = try values.decodeIfPresent(Anomaly.self, forKey: .anomaly)
    }
}

struct CurrentGpsData : Codable {
    let task : String?
    let start : CurrentStart?

    enum CodingKeys: String, CodingKey {

        case task = "task"
        case start = "start"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        task = try values.decodeIfPresent(String.self, forKey: .task)
        start = try values.decodeIfPresent(CurrentStart.self, forKey: .start)
    }
}

struct CurrentStart : Codable {
    let cron : Bool?
    let stamped : Bool?
    let decision : String?
    let is_ok : Bool?

    enum CodingKeys: String, CodingKey {

        case cron = "cron"
        case stamped = "stamped"
        case decision = "decision"
        case is_ok = "is_ok"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cron = try values.decodeIfPresent(Bool.self, forKey: .cron)
        stamped = try values.decodeIfPresent(Bool.self, forKey: .stamped)
        decision = try values.decodeIfPresent(String.self, forKey: .decision)
        is_ok = try values.decodeIfPresent(Bool.self, forKey: .is_ok)
    }

}

struct TimelogData : Codable {
    let address : String?
//    let distance : Float?
    var isInjury : Bool?
    let workplace : String?
    let shiftId : Int?
    let anomalyTrackerReason : AnomalyTrackerReason?
    let autoClockOut : Bool?
    let deviceDetails : DeviceDetails?
    let autoClockIn : Bool?
    
    enum CodingKeys: String, CodingKey {

        case address = "address"
//        case distance = "distance"
        case isInjury = "isInjury"
        case workplace = "workplace"
        case shiftId = "shiftId"
        case anomalyTrackerReason = "anomalyTrackerReason"
        case autoClockOut = "autoClockOut"
        case deviceDetails = "deviceDetails"
        case autoClockIn = "autoClockIn"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
//        distance = try values.decodeIfPresent(Float.self, forKey: .distance)
        isInjury = try values.decodeIfPresent(Bool.self, forKey: .isInjury)
        workplace = try values.decodeIfPresent(String.self, forKey: .workplace)
        shiftId = try values.decodeIfPresent(Int.self, forKey: .shiftId)
        anomalyTrackerReason = try values.decodeIfPresent(AnomalyTrackerReason.self, forKey: .anomalyTrackerReason)
        autoClockOut = try values.decodeIfPresent(Bool.self, forKey: .autoClockOut)
        deviceDetails = try values.decodeIfPresent(DeviceDetails.self, forKey: .deviceDetails)
        autoClockIn = try values.decodeIfPresent(Bool.self, forKey: .autoClockIn)
    }
}

struct AnomalyTrackerReason : Codable {
    let startReason : StartReason?

    enum CodingKeys: String, CodingKey {

        case startReason = "startReason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startReason = try values.decodeIfPresent(StartReason.self, forKey: .startReason)
    }

}

struct DeviceDetails : Codable {
    let device : String?
    let deviceModel : String?
    let osVersion : String?
    let appVersion : String?
    let buildNumber : String?

    enum CodingKeys: String, CodingKey {

        case device = "device"
        case deviceModel = "deviceModel"
        case osVersion = "osVersion"
        case appVersion = "appVersion"
        case buildNumber = "buildNumber"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        device = try values.decodeIfPresent(String.self, forKey: .device)
        deviceModel = try values.decodeIfPresent(String.self, forKey: .deviceModel)
        osVersion = try values.decodeIfPresent(String.self, forKey: .osVersion)
        appVersion = try values.decodeIfPresent(String.self, forKey: .appVersion)
        buildNumber = try values.decodeIfPresent(String.self, forKey: .buildNumber)
    }

}

struct StartReason : Codable {
    let reason : String?
    let autoAdjust : Bool?
    let sendNotification : Bool?
    let value : String?
    let code : String?
    let actualTime : Int?

    enum CodingKeys: String, CodingKey {

        case reason = "reason"
        case autoAdjust = "autoAdjust"
        case sendNotification = "sendNotification"
        case value = "value"
        case code = "code"
        case actualTime = "actualTime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        autoAdjust = try values.decodeIfPresent(Bool.self, forKey: .autoAdjust)
        sendNotification = try values.decodeIfPresent(Bool.self, forKey: .sendNotification)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        actualTime = try values.decodeIfPresent(Int.self, forKey: .actualTime)
    }

}

struct Anomaly : Codable {
    let start : StartAnomaly?
    let end : EndAnomaly?

    enum CodingKeys: String, CodingKey {

        case start = "start"
        case end = "end"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(StartAnomaly.self, forKey: .start)
        end = try values.decodeIfPresent(EndAnomaly.self, forKey: .end)
    }

}

struct StartAnomaly : Codable {
    let is_early : Bool?
    let is_offsite : Bool?
    let is_late : Bool?
    let comment : String?

    enum CodingKeys: String, CodingKey {

        case is_early = "is_early"
        case is_offsite = "is_offsite"
        case is_late = "is_late"
        case comment = "comment"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_early = try values.decodeIfPresent(Bool.self, forKey: .is_early)
        is_offsite = try values.decodeIfPresent(Bool.self, forKey: .is_offsite)
        is_late = try values.decodeIfPresent(Bool.self, forKey: .is_late)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
    }

}

struct EndAnomaly : Codable {
    let is_early : Bool?
    let is_offsite : Bool?
    let is_late : Bool?
    let comment : String?

    enum CodingKeys: String, CodingKey {

        case is_early = "is_early"
        case is_offsite = "is_offsite"
        case is_late = "is_late"
        case comment = "comment"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_early = try values.decodeIfPresent(Bool.self, forKey: .is_early)
        is_offsite = try values.decodeIfPresent(Bool.self, forKey: .is_offsite)
        is_late = try values.decodeIfPresent(Bool.self, forKey: .is_late)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
    }

}
