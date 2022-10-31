//
//  CompoundInterestViewController.swift
//  FinancialCalApp2
//
//  Created by Randimal Geeganage on 2022-04-08.
//

import Foundation
import UIKit

class CompoundInterestVC : UIViewController, UITextFieldDelegate {
    
    // MARK: - Textfields
    
    @IBOutlet weak var tfPresentValue: UITextField!
    @IBOutlet weak var tfFutureValue: UITextField!
    @IBOutlet weak var tfInterestRate: UITextField!
    @IBOutlet weak var tfNoOfPayments: UITextField!
    @IBOutlet weak var keyboardView: Keyboard!
    
    // MARK: - Variables
    
    var compoundInterest : CompoundInterest = CompoundInterest(presentValue: 0.0, futureValue: 0.0, interestRate: 0.0,  noOfPayments: 0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadDefaultsData("CompoundInterestHistory")
        self.loadInputWhenAppOpen()
    }
    
    /// load history data 
    func loadDefaultsData(_ historyKey :String) {
        let defaults = UserDefaults.standard
        compoundInterest.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    /// disable system keybaord popup and call view textfields from controller
    func assignDelegates() {
        tfPresentValue.delegate = self
        tfPresentValue.inputView = UIView()
        tfFutureValue.delegate = self
        tfFutureValue.inputView = UIView()
        tfInterestRate.delegate = self
        tfInterestRate.inputView = UIView()
        tfNoOfPayments.delegate = self
        tfNoOfPayments.inputView = UIView()
    }
    
    /// save text field data to relevent key
    @IBAction func editPresentSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfPresentValue.text, forKey:"compound_present")
    }
    
    /// save text field data to relevent key
    @IBAction func editFutureSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfFutureValue.text, forKey:"compound_future")
    }
    
    /// save text field data to relevent key
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfInterestRate.text, forKey:"compound_interest")
    }
    
    /// save text field data to relevent key
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        
        let defaultValue = UserDefaults.standard
        defaultValue.set(tfNoOfPayments.text, forKey:"compound_noOfPayment")
    }
    
    /// load data when app reopen
    func loadInputWhenAppOpen(){
        let defaultValue =  UserDefaults.standard
        let presentDefault = defaultValue.string(forKey:"compound_present")
        let interestRateDefault = defaultValue.string(forKey:"compound_interest")
        let noOfPayementsDefault = defaultValue.string(forKey:"compound_noOfPayment")
        let futureDefault = defaultValue.string(forKey:"compound_future")
        
        tfPresentValue.text = presentDefault
        tfFutureValue.text = futureDefault
        tfInterestRate.text = interestRateDefault
        tfNoOfPayments.text = noOfPayementsDefault
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    /// action for the clear all the data in textfield
    @IBAction func onClear(_ sender: UIButton) {
        
        tfPresentValue.text = ""
        tfFutureValue.text = ""
        tfInterestRate.text = ""
        tfNoOfPayments.text = ""
    }
    
    // execute the formulas when the calculate button clicked
    @IBAction func onCalculate(_ sender: UIButton) {
        
        if tfPresentValue.text! == "" && tfFutureValue.text! == "" &&
            tfInterestRate.text! == "" && tfNoOfPayments.text! == "" {
            
            let alertController = UIAlertController(title: "Saving Alert!", message: "There no text fields are empty  ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            /// checking one text field is empty
            
        } else if tfPresentValue.text! != "" && tfFutureValue.text! != "" &&
                    tfInterestRate.text! != "" && tfNoOfPayments.text! != "" {
            
            let alertController = UIAlertController(title: "Saving Warning!", message: "Need one empty field.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            
            //MARK: - present value calculation
        } else if tfPresentValue.text! == "" && tfFutureValue.text! != "" && tfInterestRate.text! != "" && tfNoOfPayments.text! != ""{
            
            let futureValue = Double(tfFutureValue.text!)!
            let interestValue = Double(tfInterestRate.text!)!
            let noOfPaymentsValue = Double(tfNoOfPayments.text!)!
            
            let interestDivided = interestValue/100
            
            let presentValueCalculate = futureValue / pow(1 + (interestDivided / 12), 12 * noOfPaymentsValue)
            
            tfPresentValue.text = String(format: "%.2f",presentValueCalculate)
            
            //MARK: - future value calculation
        } else if tfFutureValue.text! == "" && tfPresentValue.text! != "" && tfInterestRate.text! != "" && tfNoOfPayments.text! != "" {
            
            let presentValue = Double(tfPresentValue.text!)!
            let interestValue = Double(tfInterestRate.text!)!
            let noOfPaymentsValue = Double(tfNoOfPayments.text!)!
            
            let interestDivided = interestValue/100
            
            let futureValueCalculate = presentValue * pow (1 + (interestDivided / 12 ), 12 * noOfPaymentsValue )
            
            tfFutureValue.text = String(format: "%.2f",futureValueCalculate)
            
            //MARK: - interest rate calculation
        } else if tfInterestRate.text! == "" && tfPresentValue.text! != ""
                    && tfFutureValue.text! != "" && tfNoOfPayments.text! != "" {
            
            let presentValue = Double(tfPresentValue.text!)!
            let futureValue = Double(tfFutureValue.text!)!
            let noOfPaymentsValue = Double(tfNoOfPayments.text!)!
            let interestRateCalculate = 12 * ( pow ( ( futureValue / presentValue ), 1 / ( 12 * noOfPaymentsValue ) ) - 1 )
            
            tfInterestRate.text = String(format: "%.2f",interestRateCalculate * 100)
            
            //MARK: - no of payment calculation
        } else if tfNoOfPayments.text! == "" && tfPresentValue.text! != "" && tfFutureValue.text! != "" && tfInterestRate.text! != "" {
            
            let presentValue = Double(tfPresentValue.text!)!
            let futureValue = Double(tfFutureValue.text!)!
            let interestValue = Double(tfInterestRate.text!)!
            
            let interestDivided = interestValue/100
            
            let noOfPaymentsCalculate = log (futureValue/presentValue) / (12*log(1+interestDivided/12))
            
            tfNoOfPayments.text = String(format: "%.2f",noOfPaymentsCalculate)
            
        } else {
            
            let alertController = UIAlertController(title: "Saving Warning!", message: "Enter value(s) to calculate ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }          
        
    }
    
    /// save data in history view when save button clicked
    @IBAction func onSave(_ sender: UIButton){
        
        if tfPresentValue.text! != "" && tfFutureValue.text! != "" &&
            tfInterestRate.text! != "" && tfNoOfPayments.text! != "" {
            
            let defaults = UserDefaults.standard
            let historyString = "1. Present Value -> \(tfPresentValue.text!)\n 2. Future Value -> \(tfFutureValue.text!)\n  3. Interest Rate -> \(tfInterestRate.text!)% \n 4. No.of Payment -> \(tfNoOfPayments.text!)"
            
            compoundInterest.historyStringArray.append(historyString)
            defaults.set(compoundInterest.historyStringArray, forKey: "CompoundInterestHistory")
            
            let alertController = UIAlertController(title: "Successfull !", message: "Successfully saved your Compound Interest calculation .", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
            /// check whether fields are empty before save nill values
        } else if tfPresentValue.text! == "" || tfFutureValue.text! == "" ||
                    tfInterestRate.text! == "" || tfNoOfPayments.text! == "" {
            
            let alertController = UIAlertController(title: "Warning !", message: "One or More Input are Empty", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
            
        } else {
            
            let alertController = UIAlertController(title: "Error !", message: "Please do calculations . Save Unsuccessful", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }
        
        
        
        
    }
    
    
    
}
