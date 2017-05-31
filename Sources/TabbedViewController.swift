//
//  TabbedViewController.swift
//  XMenu
//
//  Created by Ruben Samsonyan on 5/24/17.
//  Copyright © 2017 Ruben Samsonyan. All rights reserved.
//

import UIKit

open class TabbedViewController: UIViewController {
    
    public weak var dataSource: TabbingDataSource? {
        didSet {
            menuContainerView.dataSource = dataSource
            
            _reloadDataIfNeeded()
        }
    }
    
    public weak var delegate: TabbingDelegate? {
        didSet {
            menuContainerView.delegate = delegate
            
            _reloadDataIfNeeded()
        }
    }
    
    open var menuContainerView: TabBarContainer
    open let contentContainerView: UIView
    
    public var selectedIndex: Int = 0
    public var numberOfItems: Int = 0
    
    private var _needsReload: Bool = false
    private var _menuState = TabBarStateMachine()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        menuContainerView = XMenuPagerMenuView()
        contentContainerView = UIView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        menuContainerView = XMenuPagerMenuView()
        contentContainerView = UIView()
        
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        menuContainerView.view.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainerView)
        view.addSubview(menuContainerView.view)
        
        menuContainerView.view.backgroundColor = UIColor.green
        view.backgroundColor = UIColor.blue
        contentContainerView.backgroundColor = UIColor.red
        
        _menuState.menuController = self
        _menuState.position = .top
        _menuState.state = .opened
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self._menuState.position = .bottom
            
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self._menuState.state = .closed
                
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self._menuState.state = .openedOverContent
                    
                    let deadlineTime = DispatchTime.now() + .seconds(2)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self._menuState.position = .left
                        
                        let deadlineTime = DispatchTime.now() + .seconds(2)
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                            self._menuState.state = .closed
                            
                            let deadlineTime = DispatchTime.now() + .seconds(2)
                            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                                self._menuState.state = .openedSlidingContent
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func reloadData() {
        numberOfItems = dataSource?.numberOfItems(in: self) ?? 0
        menuContainerView.reloadData()
        
        _needsReload = false
    }
    
    private func _setNeedsReload() {
        _needsReload = true
        view.setNeedsLayout()
    }
    
    private func _reloadDataIfNeeded() {
        if _needsReload {
            reloadData()
        }
    }
    
    override open func viewWillLayoutSubviews() {
        _reloadDataIfNeeded()
        
        super.viewWillLayoutSubviews()
    }
}
