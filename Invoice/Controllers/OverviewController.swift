//
//  OverviewController.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 02/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

fileprivate let kTableReuse = "OverviewTableViewReuse"

class OverviewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return traitCollection.userInterfaceStyle == .dark ? .darkContent : .lightContent }

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var totalLabel: UILabel!
    
    private let expenseList: ExpenseList
    
    init(list: ExpenseList) {
        expenseList = list
        super.init(nibName: "OverviewView", bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = expenseList.type.localized
        tableView.register(UINib(nibName: "OverviewTableCell", bundle: nil), forCellReuseIdentifier: kTableReuse)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let amounts = expenseList.items.compactMap { $0.amount?.exchangedToDefault() }
        let total = amounts.reduce(0, +)
        totalLabel.text = localizedCurrency(total, ExchangeService.defaultCurrency())
    }
    
    @IBAction private func backPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func sharePressed() {
        print("share")
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableReuse) as! OverviewTableCell
        let item = expenseList.items[indexPath.row]
        cell.title = localizedString("invoiceTitle", "\(indexPath.row+1)")
        cell.date = localizedDate(item.date ?? Date(), dateStyle: .full)
        cell.amount = item.amount?.localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        { tableView.deselectRow(at: indexPath, animated: true) }+0.5
        let item = expenseList.items[indexPath.row]
        let controller = DetailController(item: item)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
