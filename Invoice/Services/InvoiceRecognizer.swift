//
//  InvoiceService.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 04/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit
import Firebase

fileprivate let dateRegex = try! NSRegularExpression(pattern: "([0-9]{1,2}|[0-9]{4})[/.\\- ]([0-9]{1,2})[/.\\- ]([0-9]{4}|[0-9]{1,2})")
fileprivate let moneyRegex = try! NSRegularExpression(pattern: "(([A-Z]{3}) *([0-9.,]+))|(([0-9.,]+) *([A-Z]{3}))")

class InvoiceRecognizer {
    
    
    private let vision = Vision.vision().cloudTextRecognizer()
    private var job: DispatchWorkItem?
    private var queue: [UIImage] = []
    
    var delegate: InvoiceRecognizerDelegate?
    
    init() { }
    
    func cancel() {
        job?.cancel()
        queue = []
        job = nil
    }
    
    func perform(on image: UIImage) { queue.append(image); perform() }
    func perform(on images: [UIImage]) { queue.append(contentsOf: images); perform() }
    
    private func perform() {
        guard job == nil else { return }
        
        job = DispatchWorkItem {
            
            while !self.queue.isEmpty {
                
                //TODO: refactor
                let image = self.queue.removeFirst()
                let visionImage = VisionImage(image: image)
                
                do {
                    let semaphore = DispatchSemaphore(value: 0)
                
                    var result: VisionText?
                    var error: Error?
                    
                    self.vision.process(visionImage) { (nResult, nError) in
                        result = nResult
                        error = nError
                        semaphore.signal()
                    }
                
                    let wait = semaphore.wait(timeout: .now() + 10)
                    guard wait == .success else { throw InvoiceError.timeOut }
                    if let error = error { throw error }
                    guard let text = result else { throw InvoiceError.emptyResponse }
                    
                    
//                    let text = visionText.blocks.map({ $0.text }).joined(separator: "\n")
                    
                    let amounts = self.getPotentialAmounts(from: text)
                    let dates = self.getPotentialDates(from: text)
                    let titles = self.getPotentialTitles(from: text)
                    guard let data = image.jpegData(compressionQuality: 0.9) else { throw InvoiceError.imageConversionError }
                    
                    let item = ExpenseItem(titles: titles, amounts: amounts, dates: dates, image: data)
                    
                    item.amount = self.selectAmount(from: amounts)
                    item.date = self.selectDate(from: dates)
                    item.title = self.selectTitle(from: titles)
                    
                    ^{ self.delegate?.invoiceRecognizer(self, didGetExpenseItem: item) }
                } catch {
                    ^{ self.delegate?.invoiceRecognizer(self, didFailFor: image, error: error) }
                }
            }
            
            self.job = nil
        }
        
        ~{ self.job?.perform() }
    }
    
    //MARK: Amount
    
    private func getPotentialAmounts(from text: VisionText) -> [BoundingBox<Money>] {
        var money: [BoundingBox<Money>] = []
        for block in text.blocks {
            guard let blockMoney = firstAmount(in: block.text) else { continue }
            let lineMoney = block.lines.compactMap { ($0, firstAmount(in: $0.text)) }.filter({ $0.1 != nil })
            if lineMoney.isEmpty {
                money.append(BoundingBox(frame: block.frame, content: blockMoney))
            } else {
                let moneys = lineMoney.map { BoundingBox(frame: $0.0.frame, content: $0.1!) }
                money.append(contentsOf: moneys)
            }
            
        }
        return money
    }
    
    private func firstAmount(in string: String) -> Money? {
        let range = NSRange(location: 0, length: string.count)
        guard let match = moneyRegex.firstMatch(in: string, options: [], range: range) else { return nil }
        return parseMoney(from: match, original: string)
    }
    
    private func parseMoney(from result: NSTextCheckingResult, original: String) -> Money? {
        let ranges = (0..<result.numberOfRanges).compactMap { Range(result.range(at: $0), in: original) }
        let groups = ranges.map { String(original[$0]) }
        let components = Array(groups.dropFirst())
        
        let i = components[1].rangeOfCharacter(from: .decimalDigits) == nil ? 1 : 2
        
        let currency = components[i]
        var number = components[i == 1 ? 2 : 1]
        
        if !number.contains("."), let start = number.lastIndex(of: ",") {
            let end = number.index(start, offsetBy: 1)
            number.replaceSubrange(start..<end, with: ".")
        }
        number.removeAll { $0 == ","}
        
        guard let amount = Float(number) else { return nil }
        
        if let available = ExchangeService.availableCurrencies() {
            if !available.contains(currency) { return nil }
        } else {
            if currencySymbol(currency) == nil { return nil }
        }

        return Money(amount: amount, currency: currency)
    }
    
    private func selectAmount(from amounts: [BoundingBox<Money>]) -> Money? {
        return amounts.max(by: { $0.content.amount < $1.content.amount})?.content
    }
    
    
    //MARK: Dates
    
    private func getPotentialDates(from text: VisionText) -> [BoundingBox<Date>] {
        var date: [BoundingBox<Date>] = []
        for block in text.blocks {
            guard let blockDate = firstDate(in: block.text) else { continue }
            let lineDate = block.lines.compactMap { ($0, firstDate(in: $0.text)) }.filter({ $0.1 != nil })
            if lineDate.isEmpty {
                date.append(BoundingBox(frame: block.frame, content: blockDate))
            } else {
                let dates = lineDate.map { BoundingBox(frame: $0.0.frame, content: $0.1!) }
                date.append(contentsOf: dates)
            }
            
        }
        return date
    }
    
    private func firstDate(in string: String) -> Date? {
        let range = NSRange(location: 0, length: string.count)
        guard let match = dateRegex.firstMatch(in: string, options: [], range: range) else { return nil }
        return parseDate(from: match, original: string)
    }
    
    
    private func parseDate(from result: NSTextCheckingResult, original: String) -> Date? {
        let ranges = (0..<result.numberOfRanges).compactMap { Range(result.range(at: $0), in: original) }
        let groups = ranges.map { String(original[$0]) }
        let components = Array(groups.dropFirst())

        let i = components.firstIndex { $0.count == 4 } ?? 2
        guard let year = Int(components[i]) else { return nil }
        guard let day = Int(components[i == 2 ? 0 : 1]) else { return nil }
        guard let month = Int(components[i == 2 ? 1 : 2]) else { return nil }
        
        var date = DateComponents()
        date.calendar = Calendar(identifier: .gregorian)
        date.year = year
        date.day = month > 12 ? month : day
        date.month = month > 12 ? day : month
        
        return date.date
    }
    
    private func selectDate(from dates: [BoundingBox<Date>]) -> Date? {
        return dates.max(by: { $0.content < $1.content })?.content
    }
    
    //MARK: Title [best effort]
    
    private func getPotentialTitles(from text: VisionText) -> [BoundingBox<String>] {
        var title: [BoundingBox<String>] = []
        for block in text.blocks {
            guard let blockTitle = firstTitle(in: block.text) else { continue }
            let lineTitle = block.lines.compactMap { ($0, firstTitle(in: $0.text)) }.filter({ $0.1 != nil })
            if lineTitle.isEmpty {
                title.append(BoundingBox(frame: block.frame, content: blockTitle))
            } else {
                let titles = lineTitle.map { BoundingBox(frame: $0.0.frame, content: $0.1!) }
                title.append(contentsOf: titles)
            }
            
        }
        return title
    }
    
    private func firstTitle(in string: String) -> String? {
        
        return nil
    }
    
    private func selectTitle(from dates: [BoundingBox<String>]) -> String {
        //TODO: <-
        return "INSERT TITLE"
    }


    
    enum InvoiceError: Error {
        case emptyResponse
        case imageConversionError
        case timeOut
    }

}
