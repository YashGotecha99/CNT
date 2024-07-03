//
//  Color.swift
//  Kazuga
//
//  Created by Anand Kulkarni on 05/01/21.
//

import UIKit

enum VBColorEnum {
    
    case BlackColor
    case DarkGrayColor
    case GreenColor
    case BorderColor
    case RedColor
    case OrangeColor

    var description: String {
        return "\(self)"
    }
    
    func getColor()-> UIColor {        
        switch self {
        default:
            return UIColor(named: self.description) ?? UIColor()
        }
    }

}

