//
//  WorkDetailsModel.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 02/11/22.
//

import Foundation

/*struct WorkDetailsModel : Codable {
    let message : String?
    let timelog : Timelog?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case timelog = "timelog"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        timelog = try values.decodeIfPresent(Timelog.self, forKey: .timelog)
    }

}

//struct Gps_data : Codable {
//    let task : String?
//    let start : Start?
//    let end : End?
//
//    enum CodingKeys: String, CodingKey {
//
//        case task = "task"
//        case start = "start"
//        case end = "end"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        task = try values.decodeIfPresent(String.self, forKey: .task)
//        start = try values.decodeIfPresent(Start.self, forKey: .start)
//        end = try values.decodeIfPresent(End.self, forKey: .end)
//    }
//
//}

struct Expenses : Codable {
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




//struct End : Codable {
//    let cron : Bool?
//    let stamped : Bool?
//    let decision : String?
//    let is_ok : Bool?
//    let finish_button : Bool?
//
//    enum CodingKeys: String, CodingKey {
//
//        case cron = "cron"
//        case stamped = "stamped"
//        case decision = "decision"
//        case is_ok = "is_ok"
//        case finish_button = "finish_button"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        cron = try values.decodeIfPresent(Bool.self, forKey: .cron)
//        stamped = try values.decodeIfPresent(Bool.self, forKey: .stamped)
//        decision = try values.decodeIfPresent(String.self, forKey: .decision)
//        is_ok = try values.decodeIfPresent(Bool.self, forKey: .is_ok)
//        finish_button = try values.decodeIfPresent(Bool.self, forKey: .finish_button)
//    }
//
//}


struct Start : Codable {
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





//struct Overtimes : Codable {
//    let 50 : 50?
//
//    enum CodingKeys: String, CodingKey {
//
//        case 50 = "50"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        50 = try values.decodeIfPresent(50.self, forKey: .50)
//    }
//
//}

//struct 50 : Codable {
//    let code : String?
//    let multiplier : Int?
//    let name : String?
//    let value : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case code = "code"
//        case multiplier = "multiplier"
//        case name = "name"
//        case value = "value"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        code = try values.decodeIfPresent(String.self, forKey: .code)
//        multiplier = try values.decodeIfPresent(Int.self, forKey: .multiplier)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        value = try values.decodeIfPresent(String.self, forKey: .value)
//    }
//
//}



struct Gps : Codable {
    let task : String?
    let start_diff : String?
    let end_diff : String?

    enum CodingKeys: String, CodingKey {

        case task = "task"
        case start_diff = "start_diff"
        case end_diff = "end_diff"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        task = try values.decodeIfPresent(String.self, forKey: .task)
        start_diff = try values.decodeIfPresent(String.self, forKey: .start_diff)
        end_diff = try values.decodeIfPresent(String.self, forKey: .end_diff)
    }

}

struct User : Codable {
    let first_name : String?
    let last_name : String?
    let social_number : String?

    enum CodingKeys: String, CodingKey {

        case first_name = "first_name"
        case last_name = "last_name"
        case social_number = "social_number"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
    }

}


struct Timelog : Codable {
    let id : Int?
    let status : String?
    let user_id : Int?
    let task_id : Int?
    let for_date : String?
    let is_holiday : String?
    let from : Int?
    let to : Int?
    let total_hours_normal : Int?
    let total_hours_overtime : Int?
    let `break` : Int?
    let comments : String?
    let description : String?
 //   let data : Data?
    let status_note : String?
    let status_changed_by : String?
    let status_changed_on : String?
    let tip_id : String?
   // let gps_data : Gps_data?
    let gps_status : String?
    let gps_start_data : String?
    let gps_end_data : String?
    let tracker_running : Bool?
    let tracker_status : String?
    let paid_hours : String?
    let location_string : String?
    let user_image_attachment_id : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    let user : User?
    let gps : Gps?
    let attachments : [Attachments]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case user_id = "user_id"
        case task_id = "task_id"
        case for_date = "for_date"
        case is_holiday = "is_holiday"
        case from = "from"
        case to = "to"
        case total_hours_normal = "total_hours_normal"
        case total_hours_overtime = "total_hours_overtime"
        case `break` = "break"
        case comments = "comments"
        case description = "description"
        case data = "data"
        case status_note = "status_note"
        case status_changed_by = "status_changed_by"
        case status_changed_on = "status_changed_on"
        case tip_id = "tip_id"
       // case gps_data = "gps_data"
        case gps_status = "gps_status"
        case gps_start_data = "gps_start_data"
        case gps_end_data = "gps_end_data"
        case tracker_running = "tracker_running"
        case tracker_status = "tracker_status"
        case paid_hours = "paid_hours"
        case location_string = "location_string"
        case user_image_attachment_id = "user_image_attachment_id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case user = "User"
        case gps = "Gps"
        case attachments = "Attachments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        task_id = try values.decodeIfPresent(Int.self, forKey: .task_id)
        for_date = try values.decodeIfPresent(String.self, forKey: .for_date)
        is_holiday = try values.decodeIfPresent(String.self, forKey: .is_holiday)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        total_hours_normal = try values.decodeIfPresent(Int.self, forKey: .total_hours_normal)
        total_hours_overtime = try values.decodeIfPresent(Int.self, forKey: .total_hours_overtime)
        `break` = try values.decodeIfPresent(Int.self, forKey: .break)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        description = try values.decodeIfPresent(String.self, forKey: .description)
   //     data = try values.decodeIfPresent(Data.self, forKey: .data)
        status_note = try values.decodeIfPresent(String.self, forKey: .status_note)
        status_changed_by = try values.decodeIfPresent(String.self, forKey: .status_changed_by)
        status_changed_on = try values.decodeIfPresent(String.self, forKey: .status_changed_on)
        tip_id = try values.decodeIfPresent(String.self, forKey: .tip_id)
     //   gps_data = try values.decodeIfPresent(Gps_data.self, forKey: .gps_data)
        gps_status = try values.decodeIfPresent(String.self, forKey: .gps_status)
        gps_start_data = try values.decodeIfPresent(String.self, forKey: .gps_start_data)
        gps_end_data = try values.decodeIfPresent(String.self, forKey: .gps_end_data)
        tracker_running = try values.decodeIfPresent(Bool.self, forKey: .tracker_running)
        tracker_status = try values.decodeIfPresent(String.self, forKey: .tracker_status)
        paid_hours = try values.decodeIfPresent(String.self, forKey: .paid_hours)
        location_string = try values.decodeIfPresent(String.self, forKey: .location_string)
        user_image_attachment_id = try values.decodeIfPresent(String.self, forKey: .user_image_attachment_id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        gps = try values.decodeIfPresent(Gps.self, forKey: .gps)
        attachments = try values.decodeIfPresent([Attachments].self, forKey: .attachments)
    }

}*/


struct WorkDetailsModel : Codable {
    let message : String?
    let timelog : Timelog?
}


struct User : Codable {

    let first_name : String?
    let last_name : String?
    let social_number : String?
    
    init(first_name: String, last_name: String, social_number: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.social_number = social_number
    }
    
}
//
//struct Data : Codable {
//    let gpsStart : String?
//    let shiftId : Int?
//
//
//
//}

struct Timelog : Codable {

    let id : Int?
    let status : String?
    let user_id : Int?
//    let task_id : Int?
    let for_date : String?
//    let is_holiday : Bool?
    let from : Int?
    let to : Int?
    let `break` : Int?
    var total_hours_normal : Int?
    var total_hours_overtime : Int?
    let comments : String?
    let description : String?
    var data : Datas?
//    let status_note : String?
//    let status_changed_by : Int?
//    let status_changed_on : String?
//   let tip_id : String?
       let gps_data : Gps_data?
//    let gps_status : String?
//    let gps_start_data : String?
//    let gps_end_data : String?
//    let tracker_running : Bool?
    let tracker_status : String?
//    let paid_hours : String?
    let location_string : String?
//    let user_image_attachment_id : String?
    let createdAt : String?
//    let updatedAt : String?
    let client_id : Int?
    let user : User?
    let gps : Gps?
    let Attachments : [Attachments]?
    let anomaly : AnomalyWorkhourData?

    init(id : Int,status : String,user_id : Int,for_date : String,from : Int,to : Int,`break` : Int,total_hours_overtime : Int,total_hours_normal : Int, comments : String, description: String, data : Datas, gps_data: Gps_data, tracker_status: String, location_string: String, client_id: Int, user: User, gps: Gps, Attachments: [Attachments], createdAt: String, anomaly: AnomalyWorkhourData) {
        self.id = id
        self.status = status
        self.client_id = client_id
        self.user_id = user_id
        self.data = data
        self.for_date = for_date
        self.from = from
        self.to = to
        self.break = `break`
        self.total_hours_normal = total_hours_normal
        self.total_hours_overtime = total_hours_overtime
        self.location_string = location_string
        self.comments = comments
        self.description = description
        self.gps_data = gps_data
        self.tracker_status = tracker_status
        self.user = user
        self.gps = gps
        self.Attachments = Attachments
        self.createdAt = createdAt
        self.anomaly = anomaly
    }
}

struct AnomalyWorkhourData : Codable {
    let start : StartAnomalyWorkHour?
    let end : EndAnomalyWorkHour?

    enum CodingKeys: String, CodingKey {

        case start = "start"
        case end = "end"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(StartAnomalyWorkHour.self, forKey: .start)
        end = try values.decodeIfPresent(EndAnomalyWorkHour.self, forKey: .end)
    }

    init(start: StartAnomalyWorkHour, end: EndAnomalyWorkHour) {
        self.start = start
        self.end = end
    }
}

struct StartAnomalyWorkHour : Codable {
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

    init(is_early: Bool, is_offsite: Bool, is_late: Bool, comment: String) {
        self.is_early = is_early
        self.is_offsite = is_offsite
        self.is_late = is_late
        self.comment = comment
    }
}

struct EndAnomalyWorkHour : Codable {
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

    init(is_early: Bool, is_offsite: Bool, is_late: Bool, comment: String) {
        self.is_early = is_early
        self.is_offsite = is_offsite
        self.is_late = is_late
        self.comment = comment
    }
}

//struct Gps_data : Codable {
//    let task : String?
//    let start : Start?
//    let systemEntry : Bool?
//    let end : End?
//}

struct Gps : Codable {
    let task : String?
    let start_diff : String?
    let end_diff : String?
  //  let timestamp : String?
    
    init(task: String, start_diff: String, end_diff: String) {
        self.task = task
        self.start_diff = start_diff
        self.end_diff = end_diff
    }
}

//struct End : Codable {
//    let cron : Bool?
//}

struct Start : Codable {
    let cron : Bool?
    let timestamp : Double?
}

struct Attachments : Codable {
    let id : Int?
    let filename : String?
    let filetype : String?
    let user_id : Int?
    let location : String?
    let to_model : String?
    let to_id : Int?
   // let data : Data?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case filename = "filename"
        case filetype = "filetype"
        case user_id = "user_id"
        case location = "location"
        case to_model = "to_model"
        case to_id = "to_id"
      //  case data = "data"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        filename = try values.decodeIfPresent(String.self, forKey: .filename)
        filetype = try values.decodeIfPresent(String.self, forKey: .filetype)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        to_model = try values.decodeIfPresent(String.self, forKey: .to_model)
        to_id = try values.decodeIfPresent(Int.self, forKey: .to_id)
       // data = try values.decodeIfPresent(Data.self, forKey: .data)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
