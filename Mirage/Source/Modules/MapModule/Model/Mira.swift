//
//  Mira.swift
//  Mirage
//
//  Created by Saad on 27/03/2023.
//

import Foundation
import CoreLocation


let colorImages = [
    "https://www.pakainfo.com/wp-content/uploads/2021/09/image-url-for-testing.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/sample-image-url-link.png",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/test-image-online.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/online-dummy-image-url.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/live-image-link.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/sample-image-url-for-testing-768x432.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/dummy-user-image-url.jpg",
    "https://loremflickr.com/cache/resized/4132_5190023274_0573807b54_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_48964327062_c7876681e9_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52706077934_9a3860e070_320_240_nofilter.jpg",
    "https://file-examples.com/storage/feee5c69f0643c59da6bf13/2017/10/file_example_PNG_500kB.png",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/image-url-for-testing.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/sample-image-url-link.png",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/test-image-online.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/online-dummy-image-url.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/live-image-link.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/sample-image-url-for-testing-768x432.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/dummy-user-image-url.jpg",
    "https://loremflickr.com/cache/resized/4132_5190023274_0573807b54_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_48964327062_c7876681e9_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52706077934_9a3860e070_320_240_nofilter.jpg",
    "https://file-examples.com/storage/feee5c69f0643c59da6bf13/2017/10/file_example_PNG_500kB.png",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/image-url-for-testing.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/sample-image-url-link.png",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/test-image-online.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/online-dummy-image-url.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/live-image-link.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/sample-image-url-for-testing-768x432.jpg",
    "https://www.pakainfo.com/wp-content/uploads/2021/09/dummy-user-image-url.jpg",
    "https://loremflickr.com/cache/resized/4132_5190023274_0573807b54_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_48964327062_c7876681e9_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52706077934_9a3860e070_320_240_nofilter.jpg",
    "https://file-examples.com/storage/feee5c69f0643c59da6bf13/2017/10/file_example_PNG_500kB.png"
]

let blackImages = [
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_48501044112_b62a220340_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52747367133_bee0e8e81f_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_50735941456_c1d432b10c_320_240_nofilter.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg",
    "https://loremflickr.com/cache/resized/65535_52683775009_5280017408_n_320_240_g.jpg"
]

enum ARMediaContentType {
    case PHOTO
    case VIDEO
}

enum ShapeType {
    case PLANE
    case CUBE
    case SPHERE
}

enum ModifierType {
    case NONE
    case TRANSPARENCY
    case SPIN
}

struct ARMedia {
    let id: String
    let contentType: ARMediaContentType
    let assetUrl: String
    let shape: ShapeType
    let modifier: ModifierType
    let position: String // update to actual transform
}

struct Mira {
    let id: String
    let location: CLLocationCoordinate2D
    let isViewed: Bool
    let isFriend: Bool
    let hasCollected: Bool
    let arMedia: [ARMedia]
    let creator: Creator
    var imageUrl: String {
        get {
            return isViewed ? creator.profileImageDesaturated : creator.profileImage
        }
    }
    
    struct Creator {
        let id: String
        let profileImage: String
        let profileImageDesaturated: String
        let userName: String

        init(id: String, profileImage: String, profileImageDesaturated: String, userName: String) {
            self.id = id
            self.profileImage = profileImage
            self.profileImageDesaturated = profileImageDesaturated
            self.userName = userName
        }
        init(creator: MirageAPI.GetMirasQuery.Data.GetMira.Creator?) {
            
            id = creator?.id ?? "0"
            profileImage = creator?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
            userName = creator?.username ?? ""
            profileImageDesaturated = creator?.profileImageDesaturated ?? blackImages[Int.random(in: 0..<blackImages.count)]
        }

    }
}

extension Mira {
    
    init(mira: MirageAPI.GetMirasQuery.Data.GetMira?) {
        id = mira?.id ?? "0"
        if let loc = mira?.location {
            location = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        } else {
            location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        isViewed = mira?.viewed ?? false
        isFriend = mira?.isFriend ?? false
        hasCollected = mira?.collected ?? false
        arMedia = []
        creator = Creator(creator: mira?.creator)
    }
}
extension Mira {
    static func dummyMiras() -> [Mira] {
        
        var coordinates = [CLLocationCoordinate2D]()
        for _ in 0...32 {
            let coord = generateRandomCoordinates(min: 100, max: 1000)
            coordinates.append(coord)
        }
       /* let coordinates = [CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.790610, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.740610, longitude: -73.935242),
                           CLLocationCoordinate2D(latitude: 40.710610, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.750610, longitude: -73.932842),
                           CLLocationCoordinate2D(latitude: 40.790610, longitude: -73.915242),
                           CLLocationCoordinate2D(latitude: 40.740610, longitude: -73.935242)
        ]*/
        
        var miras = [Mira]()
        for i in 0..<colorImages.count {
            let creator = Mira.Creator(id: "\(i)", profileImage: colorImages[i], profileImageDesaturated: blackImages[i], userName: "\(i)")
            let mira = Mira(id: "\(i)", location: coordinates[i], isViewed:  i%2==0, isFriend: i%3==0, hasCollected: i%4==0, arMedia: [], creator: creator)
            miras.append(mira)
        }
        
        return miras
    }
    
    
    
}
func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
    let currentLat: Double = 40.710610919784524
    let currentLong: Double = -73.91524282298014

    //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
    let meterCord = 0.00900900900901 / 1000

    //Generate random Meters between the maximum and minimum Meters
    let randomMeters = UInt(arc4random_uniform(max) + min)

    //then Generating Random numbers for different Methods
    let randomPM = arc4random_uniform(6)

    //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
    let metersCordN = meterCord * Double(randomMeters)

    //here we generate the last Coordinates
    if randomPM == 0 {
        return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
    }else if randomPM == 1 {
        return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
    }else if randomPM == 2 {
        return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
    }else if randomPM == 3 {
        return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
    }else if randomPM == 4 {
        return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
    }else {
        return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
    }

}
