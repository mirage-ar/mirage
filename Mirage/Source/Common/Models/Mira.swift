//
//  Mira.swift
//  Mirage
//
//  Created by Saad on 27/03/2023.
//

import CoreLocation
import Foundation


public struct Mira {
    let id: UUID
    let creator: User
    let location: CLLocationCoordinate2D
    let arMedia: [ARMedia]
    let collectors: [User]?
    
    // aditional social properties
    let isViewed: Bool
    let isFriend: Bool
    let hasCollected: Bool
    
    var imageUrl: String {
        get {
            return creator.profileImage
        }
    }
    
    init(id: UUID, creator: User, location: CLLocationCoordinate2D, arMedia: [ARMedia], collectors: [User]?) {
        self.id = id
        self.creator = creator
        self.location = location
        self.arMedia = arMedia
        self.collectors = collectors
        self.isViewed = false
        self.isFriend = false
        self.hasCollected = false
    }
    
    init(id: UUID, creator: User, location: CLLocationCoordinate2D, arMedia: [ARMedia], collectors: [User]?, isViewed: Bool, isFriend: Bool, hasCollected: Bool) {
        self.id = id
        self.creator = creator
        self.location = location
        self.arMedia = arMedia
        self.collectors = collectors
        self.isViewed = isViewed
        self.isFriend = isFriend
        self.hasCollected = hasCollected
    }
    
}



extension Mira {
    
    init(mira: MirageAPI.GetMirasQuery.Data.GetMira?) {
        id = UUID(uuidString: mira?.id ?? "") ?? UUID()
        
        if let loc = mira?.location {
            location = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        } else {
            location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        var collected = false
        if let collectors = mira?.collectors, collectors.count > 0 {
            var collectorsList = [User]()
            let userId = UUID(uuidString: UserDefaultsStorage().getString(for: .userId) ?? "") ?? UUID()
            for collector in collectors {
                let user = User(collector: collector)
                
                if userId == user.id {
                    collected = true
                }
                collectorsList.append(user)
            }
            self.collectors = collectorsList
        } else {
            collectors = nil
        }
        
        if let mediaArry = mira?.miraMedia {
            let arMedia = mediaArry.map { arMedia in
                let position: SIMD3<Float> = simdDoubleToFloat(arMedia.position.transform)
                let modifier = arMedia.modifier?.type ?? .none
                return ARMedia(contentType: arMedia.contentType, assetUrl: arMedia.assetUrl, shape: arMedia.shape, modifier: modifier, position: position)
            }
            
            self.arMedia = arMedia
        }
        
        hasCollected = collected
        isViewed = mira?.viewed ?? false
        isFriend = mira?.isFriend ?? false
        creator = User(creator: mira?.creator)
        arMedia = []
    }
}

// TODO: convert to [Double]
func simdDoubleToFloat(_ transform: [[Double]]) -> SIMD3<Float> {
    return SIMD3<Float>(Float(transform[0][0]), Float(transform[0][1]), Float(transform[0][2]))
    
}

// --------- DUMMY DATA ---------

extension Mira {
    
    static var dummy: Mira {
        get {
            let creator = User(id: UUID(), profileImage: "Dummy", phone: "1231234", userName: "Dummy", profileDescription: "Dummy")
            let mira = Mira(id: UUID(), creator: creator, location: CLLocationCoordinate2D(latitude: 40.710610319784524, longitude: -73.932842), arMedia: [], collectors: nil)
            return mira
        }
    }
    
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
            let creator = User(id: UUID(), profileImage: "\(i)", phone: "1231234", userName: colorImages[i], profileDescription: "")
            let mira = Mira(id: UUID(), creator: creator, location: coordinates[i], arMedia: [], collectors: nil, isViewed:  i%2==0, isFriend: i%3==0, hasCollected: i%4==0)
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
