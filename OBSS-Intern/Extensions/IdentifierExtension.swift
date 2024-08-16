//
//  ViewControllerIdentifierExtension.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 15.08.2024.
//

import UIKit

typealias ViewControllerIdentifier = UIViewController
typealias CollectionViewCellIdentifier = UICollectionViewCell
typealias TableViewCellIdentifier = UITableViewCell

extension ViewControllerIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension CollectionViewCellIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension TableViewCellIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
