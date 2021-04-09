//
//  InvoiceServiceDelegate.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 05/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

protocol InvoiceRecognizerDelegate: class {
    func invoiceRecognizer(_ recognizer: InvoiceRecognizer, didGetExpenseItem item: ExpenseItem)
    func invoiceRecognizer(_ recognizer: InvoiceRecognizer, didFailFor image: UIImage, error: Error)
}

extension InvoiceRecognizerDelegate {
    func invoiceRecognizer(_ recognizer: InvoiceRecognizer, didGetExpenseItem item: ExpenseItem) { }
    func invoiceRecognizer(_ recognizer: InvoiceRecognizer, didFailFor image: UIImage, error: Error) { }
}
