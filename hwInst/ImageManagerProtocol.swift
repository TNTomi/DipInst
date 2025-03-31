//
//  ImageManagerProtocol.swift
//  hwInst
//
//  Created by Артём Горовой on 27.02.25.
//
import UIKit
protocol ImageManagerProtocol {
    func getPreviousImage() -> UIImage?
    func getNextImage() -> UIImage?
    func addImage(_ imageURL: URL)
    func getSavedImageURLs() -> [URL]
    func loadImage(from url: URL) -> UIImage?
    func getImageCreationDate(_ url: URL) -> Date?
}

