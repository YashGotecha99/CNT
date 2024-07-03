//
//  CustomTableView.swift
//  TimeControllApp
//
//  Created by yash on 22/02/23.
//

import Foundation
import UIKit

class CustomTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
//            layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
