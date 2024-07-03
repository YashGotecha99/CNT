//
//  NotificationScreenModel.swift
//  TimeControllApp
//
//  Created by prashant on 19/05/23.
//

import Foundation
/*
 struct NotificationScreenModel : Codable {
 let id : Int?
 let user_id : Int?
 let message : String?
 //    let data : NotificationData?
 let created_at : String?
 let updated_at : String?
 
 enum CodingKeys: String, CodingKey {
 
 case id = "id"
 case user_id = "user_id"
 case message = "message"
 //        case data = "data"
 case created_at = "created_at"
 case updated_at = "updated_at"
 }
 
 init(from decoder: Decoder) throws {
 let values = try decoder.container(keyedBy: CodingKeys.self)
 id = try values.decodeIfPresent(Int.self, forKey: .id)
 user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
 message = try values.decodeIfPresent(String.self, forKey: .message)
 //        data = try values.decodeIfPresent(NotificationData.self, forKey: .data)
 created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
 updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
 }
 }
 
 struct NotificationData : Codable {
 let context : Context?
 
 enum CodingKeys: String, CodingKey {
 
 case context = "context"
 }
 
 init(from decoder: Decoder) throws {
 let values = try decoder.container(keyedBy: CodingKeys.self)
 context = try values.decodeIfPresent(Context.self, forKey: .context)
 }
 
 }
 
 struct Context : Codable {
 let source : String?
 let id : Int?
 
 enum CodingKeys: String, CodingKey {
 
 case source = "source"
 case id = "id"
 }
 
 init(from decoder: Decoder) throws {
 let values = try decoder.container(keyedBy: CodingKeys.self)
 source = try values.decodeIfPresent(String.self, forKey: .source)
 id = try values.decodeIfPresent(Int.self, forKey: .id)
 }
 
 }
 */


struct NotificationScreenModel : Codable {
    let notifications : [Notifications]?
    let pages : Int?

    enum CodingKeys: String, CodingKey {

        case notifications = "notifications"
        case pages = "pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notifications = try values.decodeIfPresent([Notifications].self, forKey: .notifications)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
    }

}


struct Notifications : Codable {
    let id : Int?
    let user_id : Int?
    let message : String?
    let data : NotificationData?
    let created_at : String?
    let updated_at : String?
    let is_unread : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case message = "message"
        case data = "data"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_unread = "is_unread"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(NotificationData.self, forKey: .data)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        is_unread = try values.decodeIfPresent(Bool.self, forKey: .is_unread)
    }

}

struct NotificationData : Codable {
    let context : Context?

    enum CodingKeys: String, CodingKey {

        case context = "context"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        context = try values.decodeIfPresent(Context.self, forKey: .context)
    }

}

struct Context : Codable {
    let source : String?
    let room : Int?
    let projectName : String?
    let id : Int?
    let title : String?
    let isChatRoomDeleted : Bool?
    let subsource : String?

    enum CodingKeys: String, CodingKey {

        case source = "source"
        case room = "room"
        case projectName = "projectName"
        case id = "id"
        case title = "title"
        case isChatRoomDeleted = "isChatRoomDeleted"
        case subsource = "subsource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        room = try values.decodeIfPresent(Int.self, forKey: .room)
        projectName = try values.decodeIfPresent(String.self, forKey: .projectName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        isChatRoomDeleted = try values.decodeIfPresent(Bool.self, forKey: .isChatRoomDeleted)
        subsource = try values.decodeIfPresent(String.self, forKey: .subsource)
    }

}


struct GpsLocationAddress : Codable {
    let result : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(String.self, forKey: .result)
    }

}

struct HomeLocationUsers : Codable {
    let user : UserHomeLocation?

    enum CodingKeys: String, CodingKey {

        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(UserHomeLocation.self, forKey: .user)
    }

}


struct UserHomeLocation : Codable {
    let id : Int?
    let username : String?
    let user_type : String?
    let address : String?
    let post_number : String?
    let post_place : String?
    let gps_data : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case username = "username"
        case user_type = "user_type"
        case address = "address"
        case post_number = "post_number"
        case post_place = "post_place"
        case gps_data = "gps_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
    }

}
