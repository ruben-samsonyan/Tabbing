//
// Created by Ruben Samsonyan on 5/26/17.
// Copyright (c) 2017 Ruben Samsonyan. All rights reserved.
//

import Foundation

public protocol TabBarContainer {
    var view: UIView { get }
    weak var dataSource: TabBarDataSource? { get set }
    weak var delegate: TabBarDelegate? { get set }

    func reloadData()
}

public extension TabBarContainer where Self: UIView {
    var view: UIView {
        return self
    }
}
