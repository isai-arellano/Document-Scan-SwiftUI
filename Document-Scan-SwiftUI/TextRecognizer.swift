//
//  TextRecognizer.swift
//  Document-Scan-SwiftUI
//
//  Created by Isaí on 17/06/22.
//

import Foundation
import Vision
import VisionKit

final class TextRecognizer {
    let cameraScan: VNDocumentCameraScan
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    private let queue = DispatchQueue(label: "Scan-codes", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    func recognizeText(withCompletionHandler completionHandler:@escaping ([String])-> Void){
        queue.async {
            let images = (0..<self.cameraScan.pageCount).compactMap({
                self.cameraScan.imageOfPage(at: $0).cgImage
            })
            let imagesAndRequest = images.map({(image: $0, request: VNRecognizeTextRequest())})
            let textPerPage = imagesAndRequest.map{image, request->String in
                let handler = VNImageRequestHandler(cgImage: image,options: [:])
                do {
                    try handler.perform([request])
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {return ""}
                    return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
                }
                catch{
                    print(error)
                    return ""
                }
            }
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
