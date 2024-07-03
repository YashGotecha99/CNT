//
//  SSGroupsModel.swift
//  Sales Suite
//
//  Created by MACBOOK on 26/09/22.
//

import Foundation
import UIKit

struct allWorkHourData {
    var workHourType: String
    var passengerName: [Passenger]
    var registerMiles: [RegisterMiles]
    var expenseTypes: [ExpenseTypes]
    var extraWork: [ExtraWork]
    init(workHourType:String,passengerName: [Passenger],registerMiles: [RegisterMiles],expenseTypes: [ExpenseTypes],extraWork: [ExtraWork]){
        self.workHourType = workHourType
        self.passengerName = passengerName
        self.registerMiles = registerMiles
        self.expenseTypes = expenseTypes
        self.extraWork = extraWork
    }
}



struct Passenger {
    var passengerName: String

    init(passengerName:String){
        self.passengerName = passengerName
    }
}


struct RegisterMiles {
    var distance: Double
    var distanceFrom: String
    var distanceTo: String
    init(distance: Double,distanceFrom: String,distanceTo: String){
        self.distance = distance
        self.distanceFrom = distanceFrom
        self.distanceTo = distanceTo
    }
}


struct ExpenseTypes {
    var workHourType: String
    var expenseType: String
    var expenseCost: String
    var expenseComment: String
//    var expenseAllPDF: [expensePDF]
    var expenseAllPDF: String
//    init(workHourType: String,expenseType: String,expenseCost: String,expenseComment: String,expenseAllPDF: [expensePDF]){
    init(workHourType: String,expenseType: String,expenseCost: String,expenseComment: String,expenseAllPDF: String){
        self.workHourType = workHourType
        self.expenseType = expenseType
        self.expenseCost = expenseCost
        self.expenseComment = expenseComment
        self.expenseAllPDF = expenseAllPDF
    }
}

struct expensePDF {
    var expensePDF: URL
    var expenseBase64: String
    init(expensePDF:URL,expenseBase64: String){
        self.expensePDF = expensePDF
        self.expenseBase64 = expenseBase64
    }
}


struct ExtraWork {
    var workHourType: String
    var extraWork: String
    var extraHours: String
    var extraWorkComment: String
//    var extraWorkAllPDF: [expensePDF]
    var extraWorkAllPDF: String
//    init(workHourType: String,extraWork: String,extraHours: String,extraWorkComment: String,extraWorkAllPDF: [expensePDF]){
    init(workHourType: String,extraWork: String,extraHours: String,extraWorkComment: String,extraWorkAllPDF: String){
        self.workHourType = workHourType
        self.extraWork = extraWork
        self.extraHours = extraHours
        self.extraWorkComment = extraWorkComment
        self.extraWorkAllPDF = extraWorkAllPDF
    }
}

struct extraWorkPDF {
    var extraWorkPDF: URL

    init(extraWorkPDF:URL){
        self.extraWorkPDF = extraWorkPDF
    }
}

class AddWorkDocumentModel {
    
    var workHourData = [allWorkHourData]()
    var passengerData = [Passenger]()
    var registerMilesData = [RegisterMiles]()
    var expenseTypesData = [ExpenseTypes]()
    var extraWorkData = [ExtraWork]()
    
    var extraWorkPDFData = [expensePDF]()
    var otherExpensePDFData = [expensePDF]()
    
    
    var workingHourdata = [ExpenseTypes]()

}

