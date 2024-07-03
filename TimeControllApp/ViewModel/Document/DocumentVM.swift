//
//  DocumentVM.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 31/05/23.
//

import UIKit
import Alamofire

class DocumentVM: NSObject {
    static let shared = DocumentVM()
    
    func documentListAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (DocumentModal) -> Void){
        
        ApiManager.shared.fetch(type: DocumentModal.self, httpMethod: .get, api: endPointURL.documentList, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func documentPreviewAPI(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (DocumentPreviewModal) -> Void){
        
        ApiManager.shared.fetch(type: DocumentPreviewModal.self, httpMethod: .get, api: endPointURL.documentPreview + "/\(id)", parameters: nil, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func obligatedDocumentListAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (DocumentModal) -> Void){
        
        ApiManager.shared.fetch(type: DocumentModal.self, httpMethod: .get, api: endPointURL.obligatedDocumentList, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
        
    func confirmDocument(parameters: parameters,completion: @escaping (DocumentModal)-> Void) {
        ApiManager.shared.post(type: DocumentModal.self, httpMethod: .post, api: endPointURL.confirmTheDocument, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}
