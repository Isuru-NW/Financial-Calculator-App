//
//  HistoryViewController.swift
//  FinancialCalApp2
//
//  Created by Randimal Geeganage on 2022-04-08.
//

import Foundation
import UIKit

class HistoryVC: UITableViewController {
    
    // MARK: - VARIABLE
    
    var history : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initHistoryInfo()
    }
    
    /// load the applicable history data which are seleceted
    func initHistoryInfo() {
        if let vcs = self.navigationController?.viewControllers {
            let previousVC = vcs[vcs.count - 2]
            
            if previousVC is MortgageVC {
                loadDefaultsData("MortgageLoanHistory")
            }
            
            if previousVC is CompoundInterestVC {
                loadDefaultsData("CompoundInterestHistory")
            }
            
            if previousVC is SavingsVC {
                loadDefaultsData("SavingsHistory")
            }
            
            if previousVC is LoanVC {
                loadDefaultsData("LoanHistory")
            }
        }
    }
    
    /// load history data to string array
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        history = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    /// create the number of rows which were stored before
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    ///  history table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableHistoryCell")!
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = history[indexPath.row]
        return cell
    }
    
}
