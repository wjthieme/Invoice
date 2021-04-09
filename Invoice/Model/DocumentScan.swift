//
//  DebugCameraScan.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 03/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//
#if targetEnvironment(simulator)
import Foundation
import VisionKit


class DocumentScan: VNDocumentCameraScan {
    
    private let images: [UIImage]
    private let titleString: String
    
    init(_ title: String = "DebugDocument") {
        let filenames = ["invoice_2"]//, "invoice_1", "invoice_2"]
        let urls = filenames.compactMap { Bundle.main.url(forResource: $0, withExtension: "jpg") }
        let datas = urls.compactMap { try? Data(contentsOf: $0) }
        self.images = datas.compactMap { UIImage(data: $0) }
        titleString = title
    }
    
    override var pageCount: Int { return images.count }

    override func imageOfPage(at index: Int) -> UIImage {
        return images[index]
    }

    override var title: String { return titleString }
    
}
#endif
