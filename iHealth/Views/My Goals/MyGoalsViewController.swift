//
//  MyGoalsViewController.swift
//  iHealth
//
//  Created by Ricardo Casanova on 16/01/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class MyGoalsViewController: BaseViewController {
    
    public var presenter: MyGoalsPresenterDelegate?
    
    private let customTitleView: CustomTitleView = CustomTitleView()
    private let shareView: ShareView = ShareView()
    private let myGoalsContainerView: UIView = UIView()
    private var myGoalsTableView: UITableView?
    private var datasource: MyGoalsDatasource?
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureNavigationBar()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
    
}

// MARK: - Setup views
extension MyGoalsViewController {
    
    /**
     * SetupViews
     */
    private func setupViews() {
        view.backgroundColor = .gray()
        edgesForExtendedLayout = []
        
        configureSubviews()
        addSubviews()
    }
    
    /**
     * ConfigureSubviews
     */
    private func configureSubviews() {
        shareView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareView)
        
        myGoalsContainerView.backgroundColor = .clear
        myGoalsTableView = UITableView(frame: myGoalsContainerView.bounds, style: .plain)
        myGoalsTableView?.tableFooterView = UIView()
        myGoalsTableView?.separatorStyle = .none
        myGoalsTableView?.rowHeight = UITableView.automaticDimension
        myGoalsTableView?.invalidateIntrinsicContentSize()
        myGoalsTableView?.backgroundColor = .clear
        myGoalsTableView?.showsVerticalScrollIndicator = false
        
        refreshControl.addTarget(self, action: #selector(userDidPullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .white()
        myGoalsTableView?.addSubview(refreshControl)
        
        registerCells()
        setupDatasource()
    }
    
    private func configureNavigationBar() {
        customTitleView.titleColor = .white()
        customTitleView.setTitle(NSLocalizedString("my_goals.title", comment: ""))
        customTitleView.subtitleColor = .white()
        customTitleView.setSubtitle(NSLocalizedString("my_goals.subtitle", comment: ""))
        navigationItem.titleView = customTitleView
    }
    
    /**
     * Register all the cells we need
     */
    private func registerCells() {
        myGoalsTableView?.register(MyGoalTableViewCell.self, forCellReuseIdentifier: MyGoalTableViewCell.identifier)
    }
    
    /**
     * Setup datasource for my goals table view
     */
    private func setupDatasource() {
        if let myGoalsTableView = myGoalsTableView {
            datasource = MyGoalsDatasource()
            myGoalsTableView.dataSource = datasource
        }
    }
    
}

// MARK: - Layout & constraints
extension MyGoalsViewController {
    
    /**
     * Add subviews
     */
    private func addSubviews() {
        view.addSubview(myGoalsContainerView)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: myGoalsContainerView)
        view.addConstraintsWithFormat("V:|[v0]|", views: myGoalsContainerView)
        
        if let myGoalsTableView = myGoalsTableView {
            myGoalsContainerView.addSubview(myGoalsTableView)
            myGoalsContainerView.addConstraintsWithFormat("H:|[v0]|", views: myGoalsTableView)
            myGoalsContainerView.addConstraintsWithFormat("V:|[v0]|", views: myGoalsTableView)
        }
    }
    
}

extension MyGoalsViewController {
    
    @objc private func userDidPullToRefresh() {
        presenter?.refresh()
    }
    
}

// MARK: - ShareViewDelegate
extension MyGoalsViewController: ShareViewDelegate {
    
    func shareViewPressed() {
        presenter?.sharePressed()
    }
    
}

extension MyGoalsViewController: MyGoalsViewInjection {
    
    func showMessageWith(title: String, message: String, actionTitle: String) {
        showAlertWith(title: title, message: message, actionTitle: actionTitle)
    }
    
    
    func loadMyGoals(_ viewModels: [MyGoalViewModel]) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.datasource?.myGoals = viewModels
            self.myGoalsTableView?.reloadData()
        }
        
    }
    
}
