//
//  CompoundOptSelectController.swift
//  FinancialCalApp2
//
//  Created by Randimal Geeganage on 2022-04-08.
//

import Foundation
import UIKit

class MortgageVC: UIViewController, UITextFieldDelegate{
    
    // MARK: - Text fields
    
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfInterestRate: UITextField!
    @IBOutlet weak var tfNoOfPayments: UITextField!
    @IBOutlet weak var tfPayment: UITextField!
    @IBOutlet weak var keyboardView: Keyboard!
    
    // MARK: - Variables
    
    var mortgage : Mortgage = Mortgage(amount: 0.0, interestRate: 0.0, noOfPayments: 0.0, payment: 0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadDefaultsData("MortgageHistory")
        self.loadInputWhenAppOpen()
        
    }
    
    /// load history data
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        mortgage.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    /// disable system keybaord popup and call view textfields from controller
    func assignDelegates() {
        tfAmount.delegate = self
        tfAmount.inputView = UIView()
        tfInterestRate.delegate = self
        tfInterestRate.inputView = UIView()
        tfNoOfPayments.delegate = self
        tfNoOfPayments.inputView = UIView()
        tfPayment.delegate = self
        tfPayment.inputView = UIView()
    }
    
    /// save text field data to relevent key
    @IBAction func editAmountSaveDefault(_ sender: UITextField)  {
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfAmount.text, forKey:"mortgageAmountField")
    }
    
    /// save text field data to relevent key
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfInterestRate.text, forKey:"mortgageInterestField")
    }
    
    /// save text field data to relevent key
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfNoOfPayments.text, forKey:"mortgageNoOfPaymentsField")
        
    }
    
    /// save text field data to relevent key
    @IBAction func editPaymentSaveDefault(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfPayment.text, forKey:"mortgagePaymentField")
        
    }
    
    /// load recent data when the app is reopen
    func loadInputWhenAppOpen(){
        let defaultValue =  UserDefaults.standard
        let amountDefault = defaultValue.string(forKey:"mortgageAmountTextField")
        let interestRateDefault = defaultValue.string(forKey:"mortgageInterestField")
        let noOfPayementsDefault = defaultValue.string(forKey:"mortgageNoOfPaymentsField")
        let paymentDefault = defaultValue.string(forKey:"mortgagePaymentField")
        
        tfAmount.text = amountDefault
        tfInterestRate.text = interestRateDefault
        tfNoOfPayments.text = noOfPayementsDefault
        tfPayment.text = paymentDefault
        
    }
    
    /// keybaord user input will display textbox
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    /// action for the clear all the data in textfield
    @IBAction func onClear(_ sender: UIButton) {
        
        tfAmount.text = ""
        tfInterestRate.text = ""
        tfNoOfPayments.text = ""
        tfPayment.text = ""
    }
    
    /// calculate when the click the calculate button
    @IBAction func onCalculate(_ sender: UIButton) {
        
        /// checking the text boxes are empty
        if tfAmount.text! == "" && tfInterestRate.text! == "" &&
            tfPayment.text! == "" && tfNoOfPayments.text! == "" {
            
            let alertController = UIAlertController(title: "Mortgage Calculation Warning !", message: "Please fill at least three fields to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            /// checkinh the text fields aren't empty
        } else if tfAmount.text! != "" && tfInterestRate.text! != "" &&
                    tfPayment.text! != "" && tfNoOfPayments.text! != "" {
            
            let alertController = UIAlertController(title: "Mortage Warning !", message: " Need one empty field.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            //MARK: - payment calculation
        } else if tfPayment.text! == "" && tfAmount.text! != "" &&
                    tfInterestRate.text! != "" && tfNoOfPayments.text! != "" {
            
            let amountValue = Double(tfAmount.text!)!
            let interestRateValue = Double(tfInterestRate.text!)!
            let noOfPaymentsValue = Double(tfNoOfPayments.text!)!
            
            let interestDivided = interestRateValue/100
            
            let payment = amountValue * ( (interestDivided/12 * pow(1 + interestDivided/12 , noOfPaymentsValue) ) / ( pow(1 + interestDivided/12 , noOfPaymentsValue) - 1 ) )
            
            tfPayment.text = String(format: "%.2f",payment )
            
            //MARK: - amount calculation
        } else if tfAmount.text! == "" && tfNoOfPayments.text! != "" &&
                    tfInterestRate.text! != "" && tfPayment.text! != ""{
            
            let noOfPaymentsValue = Double(tfNoOfPayments.text!)!
            let interestRateValue = Double(tfInterestRate.text!)!
            let paymentValue = Double(tfPayment.text!)!
            
            let interestDivided = interestRateValue/100
            
            /// mortgage amout formula - P= (M * ( pow ((1 + R/t), (n*t)) - 1 )) / ( R/t * pow((1 + R/t), (n*t)))
            
            let Present  = (paymentValue * ( pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)) - 1 )) / ( interestDivided / noOfPaymentsValue * pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)))
            
            tfAmount.text = String(format: "%.2f",Present)
            
            //MARK: -  interest rate calculation
        } else if tfInterestRate.text! == "" && tfAmount.text! != "" &&
                    tfNoOfPayments.text! != "" && tfPayment.text! != "" {
            
            let noOfPaymentsValue = Double(tfNoOfPayments.text!)!
            let paymentValue = Double(tfPayment.text!)!
            let Amount = Double(tfAmount.text!)!
            
            //            let interest =
            
            
            //            tfInterestRate.text = String(format: "%.2f", interest)
            
            
            let alertController = UIAlertController(title: "Mortgage Warning!", message: "Interest rate calculation is not defined. ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            //MARK: - number of payments calculation
        } else if tfNoOfPayments.text! == "" && tfInterestRate.text! != "" && tfAmount.text! != "" && tfPayment.text! != ""{
            
            let amountValue = Double(tfAmount.text!)!
            let interestRateValue = Double(tfInterestRate.text!)!
            let paymentValue = Double(tfPayment.text!)!
            
            let interestDivided = (interestRateValue / 100) / 12
            
            let calculatedNumOfMonths = log((paymentValue / interestDivided) / ((paymentValue / interestDivided) - amountValue)) / log(1 + interestDivided)
            
            tfNoOfPayments.text = String(format: "%.2f",calculatedNumOfMonths)
            
        } else {
            
            
            let alertController = UIAlertController(title: "Mortage Warning!", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }
        
    }
    
    /// save data in history view when save button clicked
    @IBAction func onSave(_ sender: UIButton){
        
        if tfAmount.text! != "" && tfInterestRate.text! != "" &&
            tfPayment.text! != "" && tfNoOfPayments.text! != ""
        {
            let defaults = UserDefaults.standard
            
            /// format of displaying history
            let historyString = "1. Mortgage Amount is \(tfAmount.text!)\n 2. Interest Rate is \(tfInterestRate.text!)%\n 3. No.of Payment is \(tfNoOfPayments.text!)\n 4. Payment is \(tfPayment.text!)"
            
            mortgage.historyStringArray.append(historyString)
            defaults.set(mortgage.historyStringArray, forKey: "MortgageHistory")
            
            let alertController = UIAlertController(title: "Successull !", message: "Successfully Saved Mortage calculation.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
        
        /// check text fields are empty before saving
        else if tfAmount.text == "" || tfInterestRate.text == "" ||
                    tfPayment.text == "" || tfNoOfPayments.text == ""{
            
            let alertController = UIAlertController(title: "Warning !", message: "More text field cannot be empty", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }else{
            let alertController = UIAlertController(title: "Error ! ", message: "Please do calculation. Save Unsuccessful", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
}
