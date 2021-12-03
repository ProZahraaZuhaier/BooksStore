//
//  DownloaderViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 16/11/2021.
//

import UIKit

//MARK: - Protocols
protocol SaveFileProtocol {
    func fetchDownloadedFilePath(path: URL)
}

protocol DownloadFileProtocol{
    func didFileDownloaded (status : Bool)
}

class DownloaderViewController: UIViewController {
    var bookURL : URL?
    var saveFileDelegate: SaveFileProtocol?
    var downloadStatusDelegate: DownloadFileProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .dark
    }
}
//MARK: - Download files method
extension DownloaderViewController {
    
    func downloadBook(from url : String) {
        
          let bookURL = URL(string: url)
          let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
          let downloadTask = urlSession.downloadTask(with: bookURL!)
          downloadTask.resume()
  
      }
    }
//MARK: - URLSessionDownloadDelegate

extension DownloaderViewController : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Downloaded Location -:  ",location)
     
        self.downloadStatusDelegate?.didFileDownloaded(status: true)
    
        guard let url = downloadTask.originalRequest?.url else {return}
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
              let destinationPath = documentsPath.appendingPathComponent(url.lastPathComponent)
              print("destinationPath :  \(destinationPath)")

              try? FileManager.default.removeItem(at: destinationPath)


              do {
                  try FileManager.default.copyItem(at: location, to: destinationPath)
                  self.bookURL = destinationPath
                  self.saveFileDelegate?.fetchDownloadedFilePath(path: destinationPath)
}
        catch {
        print("Error : \(error.localizedDescription)")
              }
        

}

}
