//
//  BookReader.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 06/12/2021.
//

import Foundation
import FolioReaderKit


class BookReader {
    var folioReader = FolioReader()
    var timeManager = TimeManager()
    
    func open(epub: String , parentViewController: UIViewController) {
        let bookURL =  URL(string: epub)
        let fileName = bookURL!.deletingPathExtension().lastPathComponent
        let readerConfiguration = self.readerConfiguration(forEpub: fileName)
       timeManager.timerGetFired(timerCounting: true)
        DispatchQueue.main.async {
            self.folioReader.presentReader(parentViewController: parentViewController , withEpubPath: epub, andConfig: readerConfiguration, shouldRemoveEpub: false)
        }}}
//MARK: - FolioReader Configuration
extension BookReader {
  func readerConfiguration(forEpub epub: String) -> FolioReaderConfig {
    let config = FolioReaderConfig(withIdentifier: epub)
    config.shouldHideNavigationOnTap = true
    config.scrollDirection = FolioReaderScrollDirection.vertical
    config.quoteCustomBackgrounds = []
    config.nightModeBackground = .black
    config.menuTextColor = .systemOrange
    config.tintColor = .systemOrange
    if let image = UIImage(named: "demo-bg") {
        let customImageQuote = QuoteImage(withImage: image, alpha: 0.6, backgroundColor: UIColor.black)
        config.quoteCustomBackgrounds.append(customImageQuote)
    }
    let textColor = UIColor(red:0.86, green:0.73, blue:0.70, alpha:1.0)
    let customColor = UIColor(red:0.30, green:0.26, blue:0.20, alpha:1.0)
    let customQuote = QuoteImage(withColor: customColor , alpha: 1.0, textColor: textColor)
    config.quoteCustomBackgrounds.append(customQuote)
    
    return config
      
}
    
}
