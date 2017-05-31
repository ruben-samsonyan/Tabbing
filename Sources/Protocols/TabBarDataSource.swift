//
// Created by Ruben Samsonyan on 5/26/17.
// Copyright (c) 2017 Ruben Samsonyan. All rights reserved.
//

import Foundation

@objc public protocol TabBarDataSource {
    func numberOfItems(in menuController: TabbedViewController) -> Int
    func menu(_ menuController: TabbedViewController, viewForItemAtIndex index: Int) -> UIView?
    func menu(_ menuController: TabbedViewController, titleForItemAtIndex index: Int) -> UIView?
    func menu(_ menuController: TabbedViewController, imageForItemAtIndex index: Int) -> UIView?
}
