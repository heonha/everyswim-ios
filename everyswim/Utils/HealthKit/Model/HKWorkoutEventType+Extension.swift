//
//  HKWorkoutEventType+Extension.swift
//  swimmers
//
//  Created by HeonJin Ha on 2023/07/23.
//

import Foundation
import HealthKit

extension HKWorkoutEventType {
    
    var name: String {
        switch self {
        case .pause:
            return "일시정지"
        case .resume:
            return "재개"
        case .lap:
            return "랩"
        case .marker:
            return "마커"
        case .motionPaused:
            return "움직임 일시정지"
        case .motionResumed:
            return "움직임 재개"
        case .segment:
            return "분할"
        case .pauseOrResumeRequest:
            return "정지 또는 재개 요청"
        @unknown default:
            return "알수없음"
        }
    }
    
}
