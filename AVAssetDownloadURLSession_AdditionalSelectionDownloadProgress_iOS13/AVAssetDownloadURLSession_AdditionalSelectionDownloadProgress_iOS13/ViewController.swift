//
//  ViewController.swift
//  AVAssetDownloadURLSession_AdditionalSelectionDownloadProgress_iOS13
//
//  Created by Mackode - Bartlomiej Makowski on 15/05/2020.
//  Copyright © 2020 pl.mackode. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController, AVAssetDownloadDelegate {

    var sessionConfiguration: URLSessionConfiguration? = nil
    var downloadSession: AVAssetDownloadURLSession? = nil
    var asset: AVURLAsset? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "test4444")
        downloadSession = AVAssetDownloadURLSession(configuration: sessionConfiguration!, assetDownloadDelegate: self, delegateQueue: nil)
        action()
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        print("didFinishDownloadingTo", location)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        print("assetDownloadTask didLoad timeRange", timeRange)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didResolve resolvedMediaSelection: AVMediaSelection) {
        print("didResolve resolvedMediaSelection", resolvedMediaSelection)
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, willDownloadTo location: URL) {
        print("willDownloadTo", location)
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didCompleteFor mediaSelection: AVMediaSelection) {
        print("didCompleteFor mediaSelection", mediaSelection)
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange, for mediaSelection: AVMediaSelection) {
        print("aggregateAssetDownloadTask didLoad timeRange", timeRange.end.value, timeRangeExpectedToLoad.end.value)
    }

    func action() {
        asset = AVURLAsset(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!)

        var mediaSelections = [AVMediaSelection]()
        let defaultSelection = asset!.preferredMediaSelection.mutableCopy() as! AVMutableMediaSelection
        defaultSelection.select(nil, in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
        defaultSelection.select(nil, in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible)!)
        mediaSelections.append(defaultSelection)

        asset!.allMediaSelections.forEach { mediaSelection in
            let audioOption = mediaSelection.selectedMediaOption(in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
            let subtitleOption = mediaSelection.selectedMediaOption(in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
            print(">>", mediaSelection, "\n", audioOption, "\n", subtitleOption, "\n")

            let ms = mediaSelection.mutableCopy() as! AVMutableMediaSelection
            ms.select(nil, in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
            ms.select(nil, in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible)!)

            mediaSelections.append(ms)
        }

        let downloadTask = downloadSession?.aggregateAssetDownloadTask(with: asset!, mediaSelections: mediaSelections, assetTitle: "BipBop", assetArtworkData: nil, options: [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 10_000])

        downloadTask?.resume()
    }

}

