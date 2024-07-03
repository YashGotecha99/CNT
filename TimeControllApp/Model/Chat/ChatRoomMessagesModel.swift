//
//  ChatRoomMessages.swift
//  TimeControllApp
//
//  Created by prashant on 14/04/23.
//

import Foundation

struct ChatRoomMessagesModel : Codable {
    let room : Room?
    let members : [RoomMembers]?
    var lastMessages : [LastMessages]?

    enum CodingKeys: String, CodingKey {

        case room = "room"
        case members = "members"
        case lastMessages = "lastMessages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        room = try values.decodeIfPresent(Room.self, forKey: .room)
        members = try values.decodeIfPresent([RoomMembers].self, forKey: .members)
        lastMessages = try values.decodeIfPresent([LastMessages].self, forKey: .lastMessages)
    }
}

struct Room : Codable {
    let id : Int?
    let status : String?
    let image : String?
    let project_number : Int?
    let assignee_id : Int?
    let parent_id : String?
    let project_type : String?
    let contact_person : String?
    let title : String?
    let name : String?
    let post_place : String?
    let post_number : String?
    let address : String?
    let g_nr : String?
    let b_nr : String?
    let email : String?
    let phone : String?
    let description : String?
    let est_hours : String?
    let est_work : String?
    let gps_data : String?
//    let data : Data?
    let attachments : String?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    let user_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case image = "image"
        case project_number = "project_number"
        case assignee_id = "assignee_id"
        case parent_id = "parent_id"
        case project_type = "project_type"
        case contact_person = "contact_person"
        case title = "title"
        case name = "name"
        case post_place = "post_place"
        case post_number = "post_number"
        case address = "address"
        case g_nr = "g_nr"
        case b_nr = "b_nr"
        case email = "email"
        case phone = "phone"
        case description = "description"
        case est_hours = "est_hours"
        case est_work = "est_work"
        case gps_data = "gps_data"
//        case data = "data"
        case attachments = "attachments"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case user_id = "user_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        project_number = try values.decodeIfPresent(Int.self, forKey: .project_number)
        assignee_id = try values.decodeIfPresent(Int.self, forKey: .assignee_id)
        parent_id = try values.decodeIfPresent(String.self, forKey: .parent_id)
        project_type = try values.decodeIfPresent(String.self, forKey: .project_type)
        contact_person = try values.decodeIfPresent(String.self, forKey: .contact_person)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        post_place = try values.decodeIfPresent(String.self, forKey: .post_place)
        post_number = try values.decodeIfPresent(String.self, forKey: .post_number)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        g_nr = try values.decodeIfPresent(String.self, forKey: .g_nr)
        b_nr = try values.decodeIfPresent(String.self, forKey: .b_nr)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        est_hours = try values.decodeIfPresent(String.self, forKey: .est_hours)
        est_work = try values.decodeIfPresent(String.self, forKey: .est_work)
        gps_data = try values.decodeIfPresent(String.self, forKey: .gps_data)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
    }

}

struct RoomMembers : Codable {
    let user_id : Int?
    let fullname : String?
    let social_number : String?
    let user_type : String?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case fullname = "fullname"
        case social_number = "social_number"
        case user_type = "user_type"
        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}

struct LastMessages : Codable {
    var id : Int?
    var room_id : Int?
    var author_id : Int?
    var message : String?
    let data : LastMessageData?
    let created_at : String?
    let updated_at : String?
    let private_room_id : Int?
    let timestamp : String?
    var author : Int?
    let author_data : Author_data?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case room_id = "room_id"
        case author_id = "author_id"
        case message = "message"
        case data = "data"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case private_room_id = "private_room_id"
        case timestamp = "timestamp"
        case author = "author"
        case author_data = "author_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        room_id = try values.decodeIfPresent(Int.self, forKey: .room_id)
        author_id = try values.decodeIfPresent(Int.self, forKey: .author_id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LastMessageData.self, forKey: .data)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        private_room_id = try values.decodeIfPresent(Int.self, forKey: .private_room_id)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        author = try values.decodeIfPresent(Int.self, forKey: .author)
        author_data = try values.decodeIfPresent(Author_data.self, forKey: .author_data)
    }

}

struct Author_data : Codable {
    let user_id : Int?
    let fullname : String?
    let social_number : String?
    let user_type : String?
    let image : String?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case fullname = "fullname"
        case social_number = "social_number"
        case user_type = "user_type"
        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        social_number = try values.decodeIfPresent(String.self, forKey: .social_number)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        image = try values.decodeIfPresent(String.self, forKey: .image)
    }

}

struct LastMessageData : Codable {
    let image_id : Int?

    enum CodingKeys: String, CodingKey {

        case image_id = "image_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image_id = try values.decodeIfPresent(Int.self, forKey: .image_id)
    }

}
