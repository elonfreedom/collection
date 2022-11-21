//
//  NFCTool.swift
//  collection
//
//  Created by 张晖 on 2022/5/7.
//

import Foundation
import NFCReaderWriter


protocol NfcDelegate : NSObjectProtocol {
    func NfcWriteResult(result : Bool)       // 可选
    func NfcReadResult(url : String)    // 可选
}

extension NfcDelegate {
    // 在扩展中给出了默认实现的方法，在实际类中就是可选的了
    func NfcWriteResult(result : Bool) {
//        print("默认实现")
    }

    func NfcReadResult(url : String){
//        print("默认实现")
    }
}

class NFCTool: NSObject,NFCReaderDelegate{
    weak var delegate: NfcDelegate?
    var nfcUrl:String?
    let readerWriter = NFCReaderWriter.sharedInstance()
    
    func writeNFCData(url:String){
        nfcUrl = url
        if readerWriter.canWrite() {
            readerWriter.newWriterSession(with: self, isLegacy: true, invalidateAfterFirstRead: true, alertMessage: "请将iPhone贴近你的NFC标签")
            readerWriter.begin()
            self.readerWriter.detectedMessage = "写入成功"
        }
    }
    
    func readNFC(){
        readerWriter.newWriterSession(with: self, isLegacy: false, invalidateAfterFirstRead: true, alertMessage: "Nearby NFC card for read tag identifier")
        readerWriter.begin()
        self.readerWriter.detectedMessage = "detected Tag info"
    }
    
    func readerDidBecomeActive(_ session: NFCReader) {
        print("Reader did become")
    }

    func reader(_ session: NFCReader, didInvalidateWithError error: Error) {
        print("ERROR:\(error)")
        readerWriter.end()
    }
    //读取
    func reader(_ session: NFCReader, didDetect tag: __NFCTag, didDetectNDEF message: NFCNDEFMessage) {
        let tagId = readerWriter.tagIdentifier(with: tag)
        let content = contentsForMessages([message])
        
        let tagInfos = getTagInfos(tag)
        var tagInfosDetail = ""
        tagInfos.forEach { (item) in
            tagInfosDetail = tagInfosDetail + "\(item.key): \(item.value)\n"
        }
        
//        DispatchQueue.main.async {
////            self.tagIdLabel.text = "Read Tag Identifier:\(tagId.hexadecimal)"
////            self.tagInfoTextView.text = "TagInfo:\n\(tagInfosDetail)\nNFCNDEFMessage:\n\(content)"
//
//            print("Read Tag Identifier:\(tagId.hexadecimal)")
//            print("TagInfo:\n\(tagInfosDetail)\nNFCNDEFMessage:\n\(content)")
//        }
        delegate?.NfcReadResult(url: tagId.hexadecimal + "," + tagInfosDetail + content)
        self.readerWriter.alertMessage = "NFC Tag Info detected"
        self.readerWriter.end()
    }
    
    //写入
    func reader(_ session: NFCReader, didDetect tags: [NFCNDEFTag]) {
        var payloadData = Data([0x02])
//        let urls = ["apple.com", "google.com", "facebook.com"]
        payloadData.append((nfcUrl?.data(using: .utf8))!)
//        payloadData.append(urls[Int.random(in: 0..<urls.count)].data(using: .utf8)!)

        let payload = NFCNDEFPayload.init(
            format: NFCTypeNameFormat.nfcWellKnown,
            type: "U".data(using: .utf8)!,
            identifier: Data.init(count: 0),
            payload: payloadData,
            chunkSize: 0)
        let message = NFCNDEFMessage(records: [payload])

        readerWriter.write(message, to: tags.first!) { [self] (error) in
            if let err = error {
                print("ERR:\(err)")
                delegate?.NfcWriteResult(result: false)
            } else {
//                print("写入成功")
                delegate?.NfcWriteResult(result: true)
            }
            self.readerWriter.end()
            }
    }
    
    func contentsForMessages(_ messages: [NFCNDEFMessage]) -> String {
        var recordInfos = ""

        for message in messages {
            for (i, record) in message.records.enumerated() {
                recordInfos += "Record(\(i + 1)):\n"
                recordInfos += "Type name format: \(record.typeNameFormat.rawValue)\n"
                recordInfos += "Type: \(record.type as NSData)\n"
                recordInfos += "Identifier: \(record.identifier)\n"
                recordInfos += "Length: \(message.length)\n"

                if let string = String(data: record.payload, encoding: .ascii) {
                    recordInfos += "Payload content:\(string)\n"
                }
                recordInfos += "Payload raw data: \(record.payload as NSData)\n\n"
            }
        }
        return recordInfos
    }
    
    func getTagInfos(_ tag: __NFCTag) -> [String: Any] {
        var infos: [String: Any] = [:]

        switch tag.type {
        case .miFare:
            if let miFareTag = tag.asNFCMiFareTag() {
                switch miFareTag.mifareFamily {
                case .desfire:
                    infos["TagType"] = "MiFare DESFire"
                case .ultralight:
                    infos["TagType"] = "MiFare Ultralight"
                case .plus:
                    infos["TagType"] = "MiFare Plus"
                case .unknown:
                    infos["TagType"] = "MiFare compatible ISO14443 Type A"
                @unknown default:
                    infos["TagType"] = "MiFare unknown"
                }
                if let bytes = miFareTag.historicalBytes {
                    infos["HistoricalBytes"] = bytes.hexadecimal
                }
                infos["Identifier"] = miFareTag.identifier.hexadecimal
            }
        case .iso7816Compatible:
            if let compatibleTag = tag.asNFCISO7816Tag() {
                infos["TagType"] = "ISO7816"
                infos["InitialSelectedAID"] = compatibleTag.initialSelectedAID
                infos["Identifier"] = compatibleTag.identifier.hexadecimal
                if let bytes = compatibleTag.historicalBytes {
                    infos["HistoricalBytes"] = bytes.hexadecimal
                }
                if let data = compatibleTag.applicationData {
                    infos["ApplicationData"] = data.hexadecimal
                }
                infos["OroprietaryApplicationDataCoding"] = compatibleTag.proprietaryApplicationDataCoding
            }
        case .ISO15693:
            if let iso15693Tag = tag.asNFCISO15693Tag() {
                infos["TagType"] = "ISO15693"
                infos["Identifier"] = iso15693Tag.identifier
                infos["ICSerialNumber"] = iso15693Tag.icSerialNumber.hexadecimal
                infos["ICManufacturerCode"] = iso15693Tag.icManufacturerCode
            }

        case .feliCa:
            if let feliCaTag = tag.asNFCFeliCaTag() {
                infos["TagType"] = "FeliCa"
                infos["Identifier"] = feliCaTag.currentIDm
                infos["SystemCode"] = feliCaTag.currentSystemCode.hexadecimal
            }
        default:
            break
        }
        return infos
    }
}

extension Data {
    /// Hexadecimal string representation of `Data` object.
    var hexadecimal: String {
        return map { String(format: "%02x", $0) }
            .joined()
    }
}
