//
//  WorkHourModel.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 01/11/22.
//

import Foundation

struct WorkHourModel : Codable {
    let rows : [Rows]?
    let total : String?
    let pages : Int?
}

//{
//    let id : Int?
//    let status : String?
//    let client_id : Int?
//    let user_id : Int?
//    let task_id : Int?
//    let for_date : String?
//    let from : Int?
//    let to : Int?
//    let is_holiday : String?
//    let total_hours_normal : Int?
//    let total_hours_overtime : Int?
//    let break : Int?
//    let comments : String?
//    let description : String?
//    let data : Data?
//    let created_at : String?
//    let updated_at : String?
//    let actual_added_by : String?
//    let status_note : String?
//    let status_changed_by : String?
//    let status_changed_on : String?
//    let gps_status : String?
//    let gps_start_data : String?
//    let gps_end_data : String?
//    let gps_data : Gps_data?
//    let tracker_running : Bool?
//    let tracker_status : String?
//    let paid_hours : String?
//    let location_string : String?
//    let user_image_attachment_id : String?
//    let tip_id : String?
//    let first_name : String?
//    let last_name : String?
//    let social_number : String?
//    let task_number : Int?
//    let task_name : String?
//    let project_number : Int?
//    let project_name : String?
//    let validateTimetrackOption : Bool?
//    let startVariation : String?
//    let endVariation : String?
//    let startVariationNumber : Int?
//    let endVariationNumber : Int?
//    let unitedVariation : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case status = "status"
//        case client_id = "client_id"
//        case user_id = "user_id"
//        case task_id = "task_id"
//        case for_date = "for_date"
//        case from = "from"
//        case to = "to"
//        case is_holiday = "is_holiday"
//        case total_hours_normal = "total_hours_normal"
//        case total_hours_overtime = "total_hours_overtime"
//        case break = "break"
//        case comments = "comments"
//        case description = "description"
//        case data = "data"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case actual_added_by = "actual_added_by"
//        case status_note = "status_note"
//        case status_changed_by = "status_changed_by"
//        case status_changed_on = "status_changed_on"
//        case gps_status = "gps_status"
//        case gps_start_data = "gps_start_data"
//        case gps_end_data = "gps_end_data"
//        case gps_data = "gps_data"
//        case tracker_running = "tracker_running"
//        case tracker_status = "tracker_status"
//        case paid_hours = "paid_hours"
//        case location_string = "location_string"
//        case user_image_attachment_id = "user_image_attachment_id"
//        case tip_id = "tip_id"
//        case first_name = "first_name"
//        case last_name = "last_name"
//        case social_number = "social_number"
//        case task_number = "task_number"
//        case task_name = "task_name"
//        case project_number = "project_number"
//        case project_name = "project_name"
//        case validateTimetrackOption = "validateTimetrackOption"
//        case startVariation = "startVariation"
//        case endVariation = "endVariation"
//        case startVariationNumber = "startVariationNumber"
//        case endVariationNumber = "endVariationNumber"
//        case unitedVariation = "unitedVariation"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
//        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
//        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
//        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
//        from = try values.decodeIfPresent(Int.self, forKey: .from)
//        to = try values.decodeIfPresent(Int.self, forKey: .to)
//        is_holiday = try values.decodeIfPresent(String.self, forKey: .is_holiday)
//        total_hours_normal = try values.decodeIfPresent(Int.self, forKey: .total_hours_normal)
//        total_hours_overtime = try values.decodeIfPresent(Int.self, forKey: .total_hours_overtime)
//        break = try values.decodeIfPresent(Int.self, forKey: .break)
//        comments = try values.decodeIfPresent(String.self, forKey: .comments)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//        actual_added_by = try values.decodeIfPresent(String.self, forKey: .actual_added_by)
//        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
//        status_changed_by = try values.decodeIfPresent(String.self, forKey: .status_changed_by)
//        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
//        gps_status = try values.decodeIfPresent(String.self, forKey: .gps_status)
//        gps_start_data = try values.decodeIfPresent(String.self, forKey: .gps_start_data)
//        gps_end_data = try values.decodeIfPresent(String.self, forKey: .gps_end_data)
//        gps_data = try values.decodeIfPresent(Gps_data.self, forKey: .gps_data)
//        tracker_running = try values.decodeIfPresent(Bool.self, forKey: .tracker_running)
//        tracker_status = try values.decodeIfPresent(String.self, forKey: .tracker_status)
//        paid_hours = try values.decodeIfPresent(String.self, forKey: .paid_hours)
//        location_string = try values.decodeIfPresent(String.self, forKey: .location_string)
//        user_image_attachment_id = try values.decodeIfPresent(String.self, forKey: .user_image_attachment_id)
//        tip_id = try values.decodeIfPresent(String.self, forKey: .tip_id)
//        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
//        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
//        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
//        task_number = try values.decodeIfPresent(Int.self, forKey: .task_number)
//        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
//        project_number = try values.decodeIfPresent(Int.self, forKey: .project_number)
//        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
//        validateTimetrackOption = try values.decodeIfPresent(Bool.self, forKey: .validateTimetrackOption)
//        startVariation = try values.decodeIfPresent(String.self, forKey: .startVariation)
//        endVariation = try values.decodeIfPresent(String.self, forKey: .endVariation)
//        startVariationNumber = try values.decodeIfPresent(Int.self, forKey: .startVariationNumber)
//        endVariationNumber = try values.decodeIfPresent(Int.self, forKey: .endVariationNumber)
//        unitedVariation = try values.decodeIfPresent(String.self, forKey: .unitedVariation)
//    }
//
//}

struct Rows : Codable {
    let id : Int?
    let status : String?
    let client_id : Int?
    let user_id : Int?
    var data : Dataa?
    let task_id : Int?
    let for_date : String?
    let from : Int?
    let to : Int?
    let `break` : Int?
    let total_hours_overtime : Int?
    let total_hours_normal : Int?
    let task_number : Int?
    let task_name : String?
    let project_name : String?
    let location_string : String?
    let first_name : String?
    let last_name : String?
    let gps_data : Gps_dataRow?
    let anomaly : AnomalyWorkHours?
    let int_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case client_id = "client_id"
        case user_id = "user_id"
        case data = "data"
        case task_id = "task_id"
        case for_date = "for_date"
        case from = "from"
        case to = "to"
        case `break` = "break"
        case total_hours_overtime = "total_hours_overtime"
        case total_hours_normal = "total_hours_normal"
        case task_number = "task_number"
        case task_name = "task_name"
        case project_name = "project_name"
        case location_string = "location_string"
        case first_name = "first_name"
        case last_name = "last_name"
        case gps_data = "gps_data"
        case anomaly = "anomaly"
        case int_id = "int_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        data = try values.decodeIfPresent(Dataa.self, forKey: .data)

        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        total_hours_overtime = try values.decodeIfPresent(Int.self, forKey: .total_hours_overtime)
        total_hours_normal = try values.decodeIfPresent(Int.self, forKey: .total_hours_normal)

        `break` = try values.decodeIfPresent(Int.self, forKey: .`break`)

        task_number = try values.decodeIfPresent(Int.self, forKey: .task_number)
        task_name = try values.decodeIfPresent(String.self, forKey: .task_name)
        project_name = try values.decodeIfPresent(String.self, forKey: .project_name)
        location_string = try values.decodeIfPresent(String.self, forKey: .location_string)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        gps_data = try values.decodeIfPresent(Gps_dataRow.self, forKey: .gps_data)
        anomaly = try values.decodeIfPresent(AnomalyWorkHours.self, forKey: .anomaly)
        int_id = try values.decodeIfPresent(Int.self, forKey: .int_id)
    }
    
    init(id : Int,status : String,client_id : Int,user_id : Int,data : Dataa,task_id : Int,for_date : String,from : Int,to : Int,`break` : Int,total_hours_overtime : Int,total_hours_normal : Int,task_number : Int,task_name : String,project_name : String,location_string : String,first_name : String,last_name : String, gps_data: Gps_dataRow, anomaly: AnomalyWorkHours, int_id: Int) {
        self.id = id
        self.status = status
        self.client_id = client_id
        self.user_id = user_id
        self.data = data
        self.task_id = task_id
        self.for_date = for_date
        self.from = from
        self.to = to
        self.break = `break`
        self.total_hours_normal = total_hours_normal
        self.total_hours_overtime = total_hours_overtime
        self.task_number = task_number
        self.task_name = task_name
        self.project_name = project_name
        self.location_string = location_string
        self.first_name = first_name
        self.last_name = last_name
        self.gps_data = gps_data
        self.anomaly = anomaly
        self.int_id = int_id
    }
}

struct AnomalyWorkHours : Codable {
    let start : StartWorkHour?
    let end : EndWorkHour?

    enum CodingKeys: String, CodingKey {

        case start = "start"
        case end = "end"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(StartWorkHour.self, forKey: .start)
        end = try values.decodeIfPresent(EndWorkHour.self, forKey: .end)
    }

}

struct StartWorkHour : Codable {
    let is_early : Bool?
    let is_late : Bool?
    let is_offsite : Bool?
    let comment : String?

    enum CodingKeys: String, CodingKey {

        case is_early = "is_early"
        case is_offsite = "is_offsite"
        case comment = "comment"
        case is_late = "is_late"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_early = try values.decodeIfPresent(Bool.self, forKey: .is_early)
        is_late = try values.decodeIfPresent(Bool.self, forKey: .is_late)
        is_offsite = try values.decodeIfPresent(Bool.self, forKey: .is_offsite)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
    }

}

struct EndWorkHour : Codable {
    let is_early : Bool?
    let is_late : Bool?
    let is_offsite : Bool?
    let comment : String?

    enum CodingKeys: String, CodingKey {

        case is_early = "is_early"
        case is_offsite = "is_offsite"
        case comment = "comment"
        case is_late = "is_late"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_early = try values.decodeIfPresent(Bool.self, forKey: .is_early)
        is_late = try values.decodeIfPresent(Bool.self, forKey: .is_late)
        is_offsite = try values.decodeIfPresent(Bool.self, forKey: .is_offsite)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
    }

}

struct Gps_dataRow : Codable {
    let task : String?
    let start : StartWork?
//    let end : EndWork?

    enum CodingKeys: String, CodingKey {

        case task = "task"
        case start = "start"
//        case end = "end"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        task = try values.decodeIfPresent(String.self, forKey: .task)
        start = try values.decodeIfPresent(StartWork.self, forKey: .start)
//        end = try values.decodeIfPresent(End.self, forKey: .end)
    }
}

struct StartWork : Codable {
    let decision : String?
    let timestamp : Double?
    let is_ok : Bool?
    let locationString : String?
    let coords : CoordsStartWork?
//    let diff : Int?

    enum CodingKeys: String, CodingKey {

        case decision = "decision"
        case timestamp = "timestamp"
        case is_ok = "is_ok"
        case locationString = "locationString"
        case coords = "coords"
//        case diff = "diff"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        decision = try values.decodeIfPresent(String.self, forKey: .decision)
        timestamp = try values.decodeIfPresent(Double.self, forKey: .timestamp)
        is_ok = try values.decodeIfPresent(Bool.self, forKey: .is_ok)
        locationString = try values.decodeIfPresent(String.self, forKey: .locationString)
        coords = try values.decodeIfPresent(CoordsStartWork.self, forKey: .coords)
//        diff = try values.decodeIfPresent(Int.self, forKey: .diff)
    }

}

struct CoordsStartWork : Codable {
    let altitude : Double?
    let heading : Double?
    let latitude : Double?
    let longitude : Double?
    let speed : Double?
    let accuracy : Double?
    let altitudeAccuracy : Double?

    enum CodingKeys: String, CodingKey {

        case altitude = "altitude"
        case heading = "heading"
        case latitude = "latitude"
        case longitude = "longitude"
        case speed = "speed"
        case accuracy = "accuracy"
        case altitudeAccuracy = "altitudeAccuracy"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        altitude = try values.decodeIfPresent(Double.self, forKey: .altitude)
        heading = try values.decodeIfPresent(Double.self, forKey: .heading)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        accuracy = try values.decodeIfPresent(Double.self, forKey: .accuracy)
        altitudeAccuracy = try values.decodeIfPresent(Double.self, forKey: .altitudeAccuracy)
    }

}

struct extraWorkHour : Codable {
    let type : String?
    let value : String?
    let signature : String?
    let attachIds : String?
    let comment : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case value = "value"
        case signature = "signature"
        case attachIds = "attachIds"
        case comment = "comment"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        attachIds = try values.decodeIfPresent(String.self, forKey: .attachIds)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
    }

}

struct otherExpenses : Codable {
    let type : String?
    let value : String?
    let signature : String?
    let attachIds : String?
    let comment : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case value = "value"
        case signature = "signature"
        case attachIds = "attachIds"
        case comment = "comment"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        attachIds = try values.decodeIfPresent(String.self, forKey: .attachIds)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
    }

}

struct Datas : Codable {
    let workplace : String?
   // let emergencyClose : Bool?
    let address : String?
    let passangers : [String]?
    let expenses : [otherExpenses]?
    let extraWork : [extraWorkHour]?
    let attachments : String?
   let distance : Double?
  //  let isInjury : String?
    let signature : String?
    var overtimes : OvertimesData?
    var overtime_array : [Overtime_types]?
    let shiftId : Int?
    let anomalyTrackerReason : AnomalyTrackerReasonData?

    enum CodingKeys: String, CodingKey {

        case workplace = "workplace"
       // case emergencyClose = "emergencyClose"
        case address = "address"
        case attachments = "attachments"
       case distance = "distance"
        case passangers = "passangers"
        case expenses = "expenses"
        case extraWork = "extraWork"
        case signature = "signature"
       // case isInjury = "isInjury"
        case overtimes = "overtimes"
        case overtime_array = "overtime_array"
        case shiftId = "shiftId"
        case anomalyTrackerReason = "anomalyTrackerReason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        workplace = try values.decodeIfPresent(String.self, forKey: .workplace)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
      //  emergencyClose = try values.decodeIfPresent(Bool.self, forKey: .emergencyClose)
        address = try values.decodeIfPresent(String.self, forKey: .address)
       distance = try values.decodeIfPresent(Double.self, forKey: .distance)
       // isInjury = try values.decodeIfPresent(String.self, forKey: .isInjury)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        passangers = try values.decodeIfPresent([String].self, forKey: .passangers)
        expenses = try values.decodeIfPresent([otherExpenses].self, forKey: .expenses)
        extraWork = try values.decodeIfPresent([extraWorkHour].self, forKey: .extraWork)
        overtimes = try values.decodeIfPresent(OvertimesData.self, forKey: .overtimes)
        overtime_array = try values.decodeIfPresent([Overtime_types].self, forKey: .overtime_array)
        shiftId = try values.decodeIfPresent(Int.self, forKey: .shiftId)
        anomalyTrackerReason = try values.decodeIfPresent(AnomalyTrackerReasonData.self, forKey: .anomalyTrackerReason)
    }
    
    init(workplace:String, address:String, passangers:[String], expenses: [otherExpenses], extraWork: [extraWorkHour], attachments: String, distance: Double, signature: String, overtimes: OvertimesData, overtime_array: [Overtime_types],shiftId: Int, anomalyTrackerReason : AnomalyTrackerReasonData) {
        self.workplace = workplace
        self.address = address
        self.passangers = passangers
        self.expenses = expenses
        self.extraWork = extraWork
        self.attachments = attachments
        self.distance = distance
        self.signature = signature
        self.overtimes = overtimes
        self.overtime_array = overtime_array
        self.shiftId = shiftId
        self.anomalyTrackerReason = anomalyTrackerReason
    }
}

struct AnomalyTrackerReasonData : Codable {
    let startReason : StartReasonData?

    enum CodingKeys: String, CodingKey {

        case startReason = "startReason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startReason = try values.decodeIfPresent(StartReasonData.self, forKey: .startReason)
    }

    init(startReason:StartReasonData) {
        self.startReason = startReason
    }
}

struct StartReasonData : Codable {
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

    init(reason:String, autoAdjust:Bool, sendNotification: Bool, value: String, code: String, actualTime: Int) {
        self.reason = reason
        self.autoAdjust = autoAdjust
        self.sendNotification = sendNotification
        self.value = value
        self.code = code
        self.actualTime = actualTime
    }
}


struct OvertimetimesData : Codable {
    let code : String?
    let multiplier : Int?
    let name : String?
    let value : String?

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


struct OvertimesData : Codable {
    var fifty : Fifty?
    var hundred : Hundred?
    var other : Other?
    
    enum CodingKeys: String, CodingKey {
        
        case fifty = "50"
        case hundred = "100"
        case other = "other"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fifty = try values.decodeIfPresent(Fifty.self, forKey: .fifty)
        hundred = try values.decodeIfPresent(Hundred.self, forKey: .hundred)
        other = try values.decodeIfPresent(Other.self, forKey: .other)
    }
    
    init(fifty:Fifty,hundred:Hundred,other:Other) {
        self.fifty = fifty
        self.hundred = hundred
        self.other = other
    }
}

struct Other : Codable {
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
    
    init(code:String,multiplier:Int,name:String,value:String) {
        self.code = code
        self.multiplier = multiplier
        self.name = name
        self.value = value
    }
}

struct Fifty : Codable {
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
    
    init(code:String,multiplier:Int,name:String,value:String) {
        self.code = code
        self.multiplier = multiplier
        self.name = name
        self.value = value
    }

}

struct Hundred : Codable {
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
    
    init(code:String,multiplier:Int,name:String,value:String) {
        self.code = code
        self.multiplier = multiplier
        self.name = name
        self.value = value
    }

}

struct Dataa : Codable {
    let workplace : String?
   // let emergencyClose : Bool?
    let address : String?
    let passangers : [String]?
   let distance : Float?
    
  
    enum CodingKeys: String, CodingKey {

        case workplace = "workplace"
       // case emergencyClose = "emergencyClose"
        case address = "address"
       case distance = "distance"
        case passangers = "passangers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        workplace = try values.decodeIfPresent(String.self, forKey: .workplace)
      //  emergencyClose = try values.decodeIfPresent(Bool.self, forKey: .emergencyClose)
        address = try values.decodeIfPresent(String.self, forKey: .address)
       distance = try values.decodeIfPresent(Float.self, forKey: .distance)
        passangers = try values.decodeIfPresent([String].self, forKey: .passangers)

    }
}
 
/*
struct Dataa: Codable {
    let workplace: String?
    let address: String?
    let passangers: [String]?
    let distance: Any?
    
    enum CodingKeys: String, CodingKey {
        case workplace = "workplace"
        case address = "address"
        case distance = "distance"
        case passangers = "passangers"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        workplace = try values.decodeIfPresent(String.self, forKey: .workplace)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        passangers = try values.decodeIfPresent([String].self, forKey: .passangers)
        
        if let stringValue = try values.decodeIfPresent(String.self, forKey: .distance) {
            distance = stringValue
            
        } else if let intValue = try values.decodeIfPresent(Double.self, forKey: .distance) {
            distance = intValue
            
        } else {
            distance = nil
            
        }
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workplace, forKey: .workplace)
        try container.encode(address, forKey: .address)
        try container.encode(passangers, forKey: .passangers)
        
        if let stringValue = distance as? String {
            try container.encode(stringValue, forKey: .distance)
            
        } else if let intValue = distance as? Double {
            try container.encode(intValue, forKey: .distance)
            
        } else {
            try container.encodeNil(forKey: .distance)
            
        }
    }
}
 */

struct Gps_data : Codable {
    let task : String?
    let end : EndData?
    let start : StartData?
  
    init(task: String, end: EndData, start: StartData) {
        self.task = task
        self.end = end
        self.start = start
    }
    
}

struct End : Codable {
    let cron : Bool?
    let decision : String?

}


struct StartData : Codable {
    let coords : Coords?
    let timestamp : Double?
    let locationString : String?
    let decision : String?
    let is_ok : Bool?
//    let diff : Bool?

    enum CodingKeys: String, CodingKey {

        case coords = "coords"
        case timestamp = "timestamp"
        case locationString = "locationString"
        case decision = "decision"
        case is_ok = "is_ok"
//        case diff = "diff"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coords = try values.decodeIfPresent(Coords.self, forKey: .coords)
        timestamp = try values.decodeIfPresent(Double.self, forKey: .timestamp)
        locationString = try values.decodeIfPresent(String.self, forKey: .locationString)
        decision = try values.decodeIfPresent(String.self, forKey: .decision)
        is_ok = try values.decodeIfPresent(Bool.self, forKey: .is_ok)
//        diff = try values.decodeIfPresent(Bool.self, forKey: .diff)
    }

    init(coords: Coords, timestamp: Double, locationString: String, decision: String, is_ok: Bool) {
        self.coords = coords
        self.timestamp = timestamp
        self.locationString = locationString
        self.decision = decision
        self.is_ok = is_ok
    }
}

struct EndData : Codable {
    let coords : Coords?
    let timestamp : Double?
    let locationString : String?
    let decision : String?
    let is_ok : Bool?
//    let diff : Bool?

    enum CodingKeys: String, CodingKey {

        case coords = "coords"
        case timestamp = "timestamp"
        case locationString = "locationString"
        case decision = "decision"
        case is_ok = "is_ok"
//        case diff = "diff"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coords = try values.decodeIfPresent(Coords.self, forKey: .coords)
        timestamp = try values.decodeIfPresent(Double.self, forKey: .timestamp)
        locationString = try values.decodeIfPresent(String.self, forKey: .locationString)
        decision = try values.decodeIfPresent(String.self, forKey: .decision)
        is_ok = try values.decodeIfPresent(Bool.self, forKey: .is_ok)
//        diff = try values.decodeIfPresent(Bool.self, forKey: .diff)
    }

    init(coords: Coords, timestamp: Double, locationString: String, decision: String, is_ok: Bool) {
        self.coords = coords
        self.timestamp = timestamp
        self.locationString = locationString
        self.decision = decision
        self.is_ok = is_ok
    }
    
}

struct Coords : Codable {
    let altitude : Double?
    let altitudeAccuracy : Double?
    let latitude : Double?
    let accuracy : Double?
    let longitude : Double?
    let heading : Double?
    let speed : Double?

    enum CodingKeys: String, CodingKey {

        case altitude = "altitude"
        case altitudeAccuracy = "altitudeAccuracy"
        case latitude = "latitude"
        case accuracy = "accuracy"
        case longitude = "longitude"
        case heading = "heading"
        case speed = "speed"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        altitude = try values.decodeIfPresent(Double.self, forKey: .altitude)
        altitudeAccuracy = try values.decodeIfPresent(Double.self, forKey: .altitudeAccuracy)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        accuracy = try values.decodeIfPresent(Double.self, forKey: .accuracy)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        heading = try values.decodeIfPresent(Double.self, forKey: .heading)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
    }

    init(altitude: Double, altitudeAccuracy: Double, latitude: Double, accuracy: Double, longitude: Double, heading: Double, speed: Double ) {
        self.altitude = altitude
        self.altitudeAccuracy = altitudeAccuracy
        self.latitude = latitude
        self.accuracy = accuracy
        self.longitude = longitude
        self.heading = heading
        self.speed = speed
    }
    
}
