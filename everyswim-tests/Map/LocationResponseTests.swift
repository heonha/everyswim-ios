//
//  LocationResponseTests.swift
//  everyswim-tests
//
//  Created by HeonJin Ha on 12/10/23.
//


import XCTest
import Combine
@testable import everyswim

final class LocationResponseTests: XCTestCase {
    
    var cancellabels: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// 수영장 데이터를 가져왔는지 확인합니다. (수영장이 아니라면 false)
    func test_isPool_returns_true() {
        // given
        let jsonData = """
            {
                "lastBuildDate": "Sun, 10 Dec 2023 12:41:40 +0900",
                "total": 5,
                "start": 1,
                "display": 5,
                "items": [
                    {
                        "title": "50플러스<b>수영장</b>",
                        "link": "",
                        "category": "스포츠,오락>수영장",
                        "description": "",
                        "telephone": "",
                        "address": "서울특별시 구로구 천왕동 14-120",
                        "roadAddress": "서울특별시 구로구 오류로 36-25",
                        "mapx": "1268418947",
                        "mapy": "374883558"
                    },
                ]
            }
            """.data(using: .utf8)!

        // when
        do {
            let locationData = try JSONDecoder().decode(LocationResponse.self, from: jsonData)

            // then
            XCTAssertFalse(locationData.items.isEmpty, "위치 데이터가 비어있습니다.")
            XCTAssertTrue(locationData.items.first!.isPool, "수영장 데이터를 가져왔는지 확인합니다. true라면 수영장 입니다.")
        } catch {
            // then
            if error is DecodingError {
                XCTFail("디코딩 에러: \(error.localizedDescription)")
            } else {
                XCTFail("에러발생: \(error.localizedDescription)")
            }
        }
    }
    
    /// 수영장이 아닌 곳을 잘 구분하는지 확인합니다.
    func test_isPool_returns_false() {
        // given
        let jsonData = """
            {
                "lastBuildDate": "Sun, 10 Dec 2023 12:41:40 +0900",
                "total": 5,
                "start": 1,
                "display": 5,
                "items": [
                    {
                        "title": "<b>청주</b>실내<b>수영</b>장주차장",
                        "link": "",
                        "category": "교통시설>주차장",
                        "description": "",
                        "telephone": "",
                        "address": "충청북도 청주시 서원구 사직동 888-1",
                        "roadAddress": "",
                        "mapx": "1274696397",
                        "mapy": "366403423"
                    }
                ]
            }
            """.data(using: .utf8)!

        // when
        do {
            let locationData = try JSONDecoder().decode(LocationResponse.self, from: jsonData)

            // then
            XCTAssertFalse(locationData.items.isEmpty, "위치 데이터가 비어있습니다.")
            XCTAssertFalse(locationData.items.first!.isPool, "수영장 데이터를 가져왔는지 확인합니다. true라면 수영장 입니다.")
        } catch {
            // then
            if error is DecodingError {
                XCTFail("디코딩 에러: \(error.localizedDescription)")
            } else {
                XCTFail("에러발생: \(error.localizedDescription)")
            }
        }
    }
    
    func test_remove_title_bold() {
        let jsonData = """
            {
                "lastBuildDate": "Sun, 10 Dec 2023 12:41:40 +0900",
                "total": 5,
                "start": 1,
                "display": 5,
                "items": [
                    {
                        "title": "50플러스<b>수영장</b>",
                        "link": "",
                        "category": "스포츠,오락>수영장",
                        "description": "",
                        "telephone": "",
                        "address": "서울특별시 구로구 천왕동 14-120",
                        "roadAddress": "서울특별시 구로구 오류로 36-25",
                        "mapx": "1268418947",
                        "mapy": "374883558"
                    },
                ]
            }
            """.data(using: .utf8)!
        
        // when
        do {
            let locationData = try JSONDecoder().decode(LocationResponse.self, from: jsonData)

            // then
            XCTAssertFalse(locationData.items.isEmpty, "장소 데이터가 비어있습니다.")
            XCTAssertEqual(locationData.items.first!.name, "50플러스 수영장 ")
        } catch {
            // then
            if error is DecodingError {
                XCTFail("디코딩 에러: \(error.localizedDescription)")
            } else {
                XCTFail("에러발생: \(error.localizedDescription)")
            }
        }

        
    }
    
    func test_transfer_coordinate() {
        let jsonData = """
            {
                "lastBuildDate": "Sun, 10 Dec 2023 12:41:40 +0900",
                "total": 5,
                "start": 1,
                "display": 5,
                "items": [
                    {
                        "title": "50플러스<b>수영장</b>",
                        "link": "",
                        "category": "스포츠,오락>수영장",
                        "description": "",
                        "telephone": "",
                        "address": "서울특별시 구로구 천왕동 14-120",
                        "roadAddress": "서울특별시 구로구 오류로 36-25",
                        "mapx": "1268418947",
                        "mapy": "374883558"
                    },
                ]
            }
            """.data(using: .utf8)!
        
        // when
        do {
            let locationData = try JSONDecoder().decode(LocationResponse.self, from: jsonData)

            // then
            XCTAssertFalse(locationData.items.isEmpty, "장소 데이터가 비어있습니다.")
            XCTAssertEqual(locationData.items.first!.coordinator.latitude, 37.4883558)
            XCTAssertEqual(locationData.items.first!.coordinator.longitude, 126.8418947)
        } catch {
            // then
            if error is DecodingError {
                XCTFail("디코딩 에러: \(error.localizedDescription)")
            } else {
                XCTFail("에러발생: \(error.localizedDescription)")
            }
        }
        
    }


}

