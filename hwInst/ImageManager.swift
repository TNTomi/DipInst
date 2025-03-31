//
//  ImageManagerProtocol.swift
//  hwInst
//
//  Created by Артём Горовой on 27.02.25.
//
import UIKit

final class ImageManager: ImageManagerProtocol {
  
    private let noImage = UIImage(systemName: "photo")
    private let defaultsKey = "savedImages"
    
    private var savedImageURLs: [URL] = []
    private var currentIndex = 0
    
    init() {
        loadSavedImages()
    }
    
    func getPreviousImage() -> UIImage? {
        let images = allImages()
        guard !images.isEmpty else { return noImage }
        
        currentIndex = (currentIndex - 1 + images.count) % images.count
        return images[currentIndex]
    }
    
    func getNextImage() -> UIImage? {
        let images = allImages()
        guard !images.isEmpty else { return noImage }
        
        currentIndex = (currentIndex + 1) % images.count
        return images[currentIndex]
    }
    
    func addImage(_ imageURL: URL) {
        savedImageURLs.append(imageURL)
        saveImageURLs()
    }
    
    func getSavedImageURLs() -> [URL] {
        return savedImageURLs
    }
    
    func getImageCreationDate(_ url: URL) -> Date? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        return attributes?[.creationDate] as? Date
    }
    
    private func allImages() -> [UIImage] {
        let savedImages = savedImageURLs.compactMap { loadImage(from: $0) }
        return savedImages
    }
    
    func saveImageToDocuments(image: UIImage, fileName: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Error: Could not convert image to data")
            return nil
        }
        
        let fileManager = FileManager.default
        do {
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            try data.write(to: fileURL)
            savedImageURLs.append(fileURL)
            saveImageURLs()
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(from url: URL) -> UIImage? {
        if !FileManager.default.fileExists(atPath: url.path) {
            return noImage
        }

        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            return noImage
        }
    }
    
    private func saveImageURLs() {
        let paths = savedImageURLs.map { $0.absoluteString }
        UserDefaults.standard.set(paths, forKey: defaultsKey)
    }
    
    private func loadSavedImages() {
        savedImageURLs = (UserDefaults.standard.stringArray(forKey: defaultsKey) ?? [])
            .compactMap { URL(string: $0) }
    }
}

