//
//  MyFiles.swift
//  TimeControllApp
//
//  Created by prashant on 29/08/23.
//

import Foundation

struct MyFilesModel : Codable {
    let rows : [MyFilesRows]?
//    let total : Int?
    let pages : Int?

    enum CodingKeys: String, CodingKey {

        case rows = "rows"
//        case total = "total"
        case pages = "pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decodeIfPresent([MyFilesRows].self, forKey: .rows)
//        total = try values.decodeIfPresent(Int.self, forKey: .total)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
    }

}

struct MyFilesRows : Codable {
    let id : Int?
    let client_id : Int?
    let name : String?
    let description : String?
    let doc_type : String?
//    let data : MyFilesData?
    let status : String?
    let attachments : String?
    let created_at : String?
    let updated_at : String?
    let visible_to_all : Bool?
//    let created_by : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case client_id = "client_id"
        case name = "name"
        case description = "description"
        case doc_type = "doc_type"
//        case data = "data"
        case status = "status"
        case attachments = "attachments"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case visible_to_all = "visible_to_all"
//        case created_by = "created_by"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        doc_type = try values.decodeIfPresent(String.self, forKey: .doc_type)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        visible_to_all = try values.decodeIfPresent(Bool.self, forKey: .visible_to_all)
//        created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
    }
}

struct MyFilesByID : Codable {
    let extradoc : Extradoc?

    enum CodingKeys: String, CodingKey {

        case extradoc = "extradoc"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extradoc = try values.decodeIfPresent(Extradoc.self, forKey: .extradoc)
    }
}


struct Extradoc : Codable {
    let id : Int?
    let status : String?
    let doc_type : String?
    let name : String?
    let description : String?
    let data : ExtraDocData?
    let attachments : String?
    let visible_to_all : Bool?
    let created_by : Int?
    let createdAt : String?
    let updatedAt : String?
    let client_id : Int?
    let extraDocAttachments : [MyFilesByIdAttachments]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case doc_type = "doc_type"
        case name = "name"
        case description = "description"
        case data = "data"
        case attachments = "attachments"
        case visible_to_all = "visible_to_all"
        case created_by = "created_by"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case client_id = "client_id"
        case extraDocAttachments = "Attachments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        doc_type = try values.decodeIfPresent(String.self, forKey: .doc_type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        data = try values.decodeIfPresent(ExtraDocData.self, forKey: .data)
        attachments = try values.decodeIfPresent(String.self, forKey: .attachments)
        visible_to_all = try values.decodeIfPresent(Bool.self, forKey: .visible_to_all)
        created_by = try values.decodeIfPresent(Int.self, forKey: .created_by)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
        extraDocAttachments = try values.decodeIfPresent([MyFilesByIdAttachments].self, forKey: .extraDocAttachments)
    }

}

struct MyFilesByIdAttachments : Codable {
    let id : Int?
    let filename : String?
    let filetype : String?
    let user_id : Int?
    let location : String?
    let to_model : String?
    let to_id : Int?
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
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

struct ExtraDocData : Codable {
    let disableAvailableForEverybody : Bool?

    enum CodingKeys: String, CodingKey {

        case disableAvailableForEverybody = "disableAvailableForEverybody"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        disableAvailableForEverybody = try values.decodeIfPresent(Bool.self, forKey: .disableAvailableForEverybody)
    }

}
