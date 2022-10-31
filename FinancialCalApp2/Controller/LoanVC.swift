//
//  LoanController.swift
//  FinancialCalApp2
//
//  Created by Randimal Geeganage on 2022-04-08.
//

import Foundation

import UIKit

class LoanVC: UIViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var noOfPaymentsTF: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var keyboardView: Keyboard!
    
    // MARK: - Variables
    
    var loan : Loan = Loan(amount: 0.0, interestRate: 0.0, noOfPayments: 0.0, payment: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadDefaultsData("LoanHistory")
        self.loadInputWhenAppOpen()
    }
    
    /// load history data
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        loan.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    /// disable system keybaord popup and call view textfields from controller
    func assignDelegates() {
        amountTextField.delegate = self
        amountTextField.inputView = UIView()
        interestRateTextField.delegate = self
        interestRateTextField.inputView = UIView()
        noOfPaymentsTF.delegate = self
        noOfPaymentsTF.inputView = UIView()
        paymentTextField.delegate = self
        paymentTextField.inputView = UIView()
    }
    
    /// save text field data to relevent key
    @IBAction func editAmountSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(amountTextField.text, forKey:"loan_amount")
        
    }
    
    /// save text field data to relevent key
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(interestRateTextField.text, forKey:"loan_interest_rate")
    }
    
    /// save text field data to relevent key
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(noOfPaymentsTF.text, forKey:"loan_noOfPayments")
    }
    
    /// save text field data to relevent key
    @IBAction func editPaymentSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(paymentTextField.text, forKey:"loan_payment")
    }
    
    /// load recent data when the app is re open
    func loadInputWhenAppOpen(){
        let defaultValue =  UserDefaults.standard
        let amountDefault = defaultValue.string(forKey:"loan_amount")
        let interestRateDefault = defaultValue.string(forKey:"loan_interest_rate")
        let noOfPayementsDefault = defaultValue.string(forKey:"loan_noOfPayments")
        let paymentDefault = defaultValue.string(forKey:"loan_payment")
        
        amountTextField.text = amountDefault
        interestRateTextField.text = interestRateDefault
        noOfPaymentsTF.text = noOfPayementsDefault
        paymentTextField.text = paymentDefault
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    /// action for clear text fields
    @IBAction func onClear(_ sender: UIButton) {
        
        amountTextField.text = ""
        interestRateTextField.text = ""
        noOfPaymentsTF.text = ""
        paymentTextField.text = ""
    }
    
    /// calculate formula when calculate button clicked
    @IBAction func onCalculate(_ sender: UIButton) {
        
        /// check whether all textbox empty or not
        if amountTextField.text! == "" && interestRateTextField.text! == "" &&
            paymentTextField.text! == "" && noOfPaymentsTF.text! == "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            
            /// check whether all textbox filled or not
        } else if amountTextField.text! != "" && interestRateTextField.text! != "" &&
                    paymentTextField.text! != "" && noOfPaymentsTF.text! != "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: " Need one empty field.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            //MARK: - Payment calculation
            
        } else if paymentTextField.text! == "" && amountTextField.text! != "" &&
                    interestRateTextField.text! != "" && noOfPaymentsTF.text! != ""{
            
            let amountValue = Double(amountTextField.text!)!
            let interestRateValue = Double(interestRateTextField.text!)!
            let noOfPaymentsValue = Double(noOfPaymentsTF.text!)!
            
            let interestDivided = interestRateValue/100
            
            let payment = amountValue * ( (interestDivided/12 * pow(1 + interestDivided/12 , noOfPaymentsValue) ) / ( pow(1 + interestDivided/12 , noOfPaymentsValue) - 1 ) )
            
            paymentTextField.text = String(format: "%.2f",payment)
            
            //MARK: - Amount calculation
            
        } else if amountTextField.text! == "" && noOfPaymentsTF.text! != "" && interestRateTextField.text! != "" && paymentTextField.text! != "" {
            
            let noOfPaymentsValue = Double(noOfPaymentsTF.text!)!
            let interestRateValue = Double(interestRateTextField.text!)!
            let paymentValue = Double(paymentTextField.text!)!
            
            let interestDivided = interestRateValue/100
            
            let Present  = (paymentValue * ( pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)) - 1 )) / ( interestDivided / noOfPaymentsValue * pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)))
            
            amountTextField.text = String(format: "%.2f",Present)
            
            //MARK: - interest rate calculation
            
        } else if interestRateTextField.text! == "" && amountTextField.text! != "" && noOfPaymentsTF.text! != "" && paymentTextField.text! != "" {
            
            let alertController = UIAlertController(title: "Warning", message: "Interest rate calculation is not defined. ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)        
            
            //MARK: - number of payments calculation
        } else if noOfPaymentsTF.text! == "" && amountTextField.text! != "" && interestRateTextField.text! != "" && paymentTextField.text! != "" {
            
            let amountValue = Double(amountTextField.text!)!
            let interestRateValue = Double(interestRateTextField.text!)!
            let paymentValue = Double(paymentTextField.text!)!
            
            let interestDivided = (interestRateValue / 100) / 12
            let calculatNoOfMonths = log((paymentValue / interestDivided) / ((paymentValue / interestDivided) - amountValue)) / log(1 + interestDivided)
            noOfPaymentsTF.text = String(format: "%.2f",calculatNoOfMonths)
            
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }
        
    }
    
    /// save data in history view when save button clicked
    @IBAction func onSave(_ sender: UIButton){
        
        
        if amountTextField.text != "" && interestRateTextField.text != "" &&
            paymentTextField.text != "" && noOfPaymentsTF.text != ""{
            
            let defaults = UserDefaults.standard
            /// format of displaying history
            let historyString = "1. Loan Amount is \(amountTextField.text!)\n 2. Interest Rate is \(interestRateTextField.text!) %\n 3. No.of Payment is \(noOfPaymentsTF.text!)\n 4. Payment is \(paymentTextField.text!)"
            
            loan.historyStringArray.append(historyString)
            defaults.set(loan.historyStringArray, forKey: "LoanHistory")
            
            let alertController = UIAlertController(title: "Successfull", message: "Successfully Saved.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            /// check whether fields are empty before save nill values
        } else if amountTextField.text == "" || interestRateTextField.text == "" ||
                    paymentTextField.text == "" || noOfPaymentsTF.text == "" {
            
            let alertController = UIAlertController(title: "Warning! ", message: "More Text fields are Empty", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
        } else {
            
            let alertController = UIAlertController(title: "Error!", message: "Please do calculation. Save Unsuccessful", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }
        
    }
    
    
}
