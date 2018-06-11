//: Playground - noun: a place where people can play

import XCPlayground
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import RxCocoa
/*
// Create subscribe observables
exampleOf("just") { 
    let observable = Observable.just("Hello, world!")
    observable.subscribe { event in
        print(event)
    }
}

exampleOf("of") { 
    let observable = Observable.of(1, 2, 3)
    observable.subscribe { 
        print($0)
    }
    
    observable.subscribe { 
        print($0)
    }
}

exampleOf("error") { 
    enum ErrorValue: Error {
        case Test
    }
    
    Observable<Int>.error(ErrorValue.Test).subscribe { 
        print($0)
    }
}

// Work with objects

exampleOf("PublishSubject") { 
    let subject = PublishSubject<String>()
    
    subject.subscribe {
        print($0)
    }
    
    enum ErrorValue: Error {
        case Test
    }
    
    subject.on(.next("Hello"))
    //subject.onCompleted()
    //subject.onError(ErrorValue.Test)
    subject.onNext("world")
    
    let newSubscription = subject.subscribe(onNext: { (event) in
        print("New subscription: ", event)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
    
    subject.onNext("What's up?")
    
    newSubscription.dispose()
    subject.onNext("Still there?")
    
}

exampleOf("BehaviorSubject") { 
    let subject = BehaviorSubject(value: "a")
    
    subject.subscribe(onNext: { (event) in
        print(#line, event)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
    
    subject.onNext("b")
    
    subject.subscribe(onNext: { (event) in
        print(#line, event)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
}

exampleOf("ReplaySubject") { 
    let subject = ReplaySubject<Int>.create(bufferSize: 3)
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    subject.onNext(4)
    
    subject.subscribe(onNext: { (event) in
        print(event)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
}

exampleOf("Variable") { 
    let disposeBag = DisposeBag()
    let variable = Variable("A")
    
    variable.asObservable().subscribe(onNext: { (event) in
        print(event)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
    
    .disposed(by: disposeBag)
    
    variable.value = "B"
}

exampleOf("BehaviorRelay") { 
    let disposeBag = DisposeBag()
    let variable = BehaviorRelay(value: "A")
    
    variable.asObservable().subscribe(onNext: { (event) in
        print(event)
    }, onError: nil, onCompleted: nil, onDisposed: nil)
    
    .disposed(by: disposeBag)
    
    variable.accept("B")
}

// Transform observable
exampleOf("map") { 
    Observable.of(1, 2, 3)
        .map({ $0 * $0 })
        .subscribe(onNext: { (event) in
            print(event)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    .dispose()
}

exampleOf("flatMap & flatMapLatest") { 
    let disposeBag = DisposeBag()
    
    struct Player {
        let score: Variable<Int>
    }
    
    let scott = Player(score: Variable(80))
    let lori = Player(score: Variable(90))
    
    let player = Variable(scott)
    
    player.asObservable()
        .flatMapLatest { $0.score.asObservable() }
        .subscribe(onNext: { (event) in
            print(event)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    player.value.score.value = 85
    scott.score.value = 88
    
    player.value = lori
    scott.score.value = 95
    
    lori.score.value = 100
    player.value.score.value = 105
}

exampleOf("scan") { 
    let disposeBag = DisposeBag()
    let dartScore = PublishSubject<Int>()
    
    dartScore.asObservable()
        .buffer(timeSpan: 0.0, count: 3, scheduler: MainScheduler.instance)
        .map { $0.reduce(0, +) }
        .scan(501) { intermediate, newValue in
            let result = intermediate - newValue
            return result == 0 || result > 1 ? result : intermediate
        }
        .takeWhile { $0 != 0 }
        .subscribe { print($0.isStopEvent ? $0 : $0.element!) }
        .disposed(by: disposeBag)
    
    dartScore.onNext(13)
    dartScore.onNext(60)
    dartScore.onNext(50)
    dartScore.onNext(0)
    dartScore.onNext(0)
    dartScore.onNext(378)
}

// Filter observable sequences
exampleOf("filter") { 
    let disposeBag = DisposeBag()
    let numbers = Observable.generate(initialState: 1, condition: { $0 < 101 }, iterate: { $0 + 1 })
    
    //numbers.subscribe(onNext: { print($0) })
    numbers.filter { number in 
        guard number > 1 else { return false }
        var isPrime = true
        
        (2..<number).forEach({
            if number % $0 == 0 {
                isPrime = false
            }
        })
        
        return isPrime
    }
    .toArray()
    .subscribe(onNext:  { print($0) })
}

exampleOf("distinctionUntilChanged") { 
    let disposeBag = DisposeBag()
    let searchString = Variable("")
    
    searchString.asObservable()
        .map { $0.lowercased() }
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    searchString.value = "APPLE"
    searchString.value = "apple"
    searchString.value = "Banana"
    searchString.value = "APPLE"
}

exampleOf("takeWhile") { 
    let disposeBag = DisposeBag()
    let numbers = Observable.of(1, 2, 3, 4, 3, 2, 1)
    
    numbers.takeWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

// Combine observable sequences
exampleOf("startWith") { 
    let disposeBag = DisposeBag()
    
    Observable.of("1", "2", "3")
        .startWith("A")
        .startWith("B")
        .startWith("C", "D")
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

exampleOf("merge") { 
    let disposeBag = DisposeBag()
    
    let subject1 = PublishSubject<String>()
    let subject2 = PublishSubject<String>()
    Observable.of(subject1, subject2)
        .merge()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    subject1.onNext("A")
    subject1.onNext("B")
    
    subject2.onNext("1")
    subject2.onNext("2")
    
    subject1.onNext("C")
    subject2.onNext("3")
}

exampleOf("zip") { 
    let disposeBag = DisposeBag()
    
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    Observable.zip(stringSubject, intSubject) { stringElement, intElement in
        "\(stringElement) \(intElement)"
        }
        
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    stringSubject.onNext("A")
    stringSubject.onNext("B")
    
    intSubject.onNext(1)
    intSubject.onNext(2)
    
    intSubject.onNext(3)
    stringSubject.onNext("С")
}

// Perform side effects
exampleOf("doOnNext") { 
    let disposeBag = DisposeBag()
    
    Observable.of(-40, 0, 32, 70, 212)
        //.do(onNext: { $0 * $0 })
        .do(onNext: { print("\($0)℉ = ", terminator: "")})
        .map { Double($0 - 32) * 5/9.0 }
        .subscribe(onNext: { print(String(format: "%.1f℃", $0)) })
        .disposed(by: disposeBag)
}

// Uses schedulers
let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
PlaygroundPage.current.liveView = imageView

let swift = UIImage(named: "Swift")!
let swiftImageData = UIImagePNGRepresentation(swift)
let rx = UIImage(named: "Rx")!
let rxImageData = UIImagePNGRepresentation(rx)

let disposeBag = DisposeBag()

let imageDataSubject = PublishSubject<Data>()

let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

let myQueue = DispatchQueue(label: "com.stan.myConcurrentQueue", attributes: .concurrent)
let scheduler2 = SerialDispatchQueueScheduler(queue: myQueue, internalSerialQueueName: "com.stan.myConcurrentQueue")

let operationQueue = OperationQueue()
operationQueue.qualityOfService = .background
let scheduler3 = OperationQueueScheduler(operationQueue: operationQueue)

imageDataSubject
    .observeOn(scheduler3)
    .map { UIImage(data: $0 as Data) }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { imageView.image = $0 })
    .disposed(by: disposeBag)

imageDataSubject.onNext(swiftImageData!)
imageDataSubject.onNext(rxImageData!)
*/

// Debagging

func sampleWithPublish() {
    let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
    
    interval
        .debug("1st")
        .subscribe({ _ in })
    
    delay(delay: 2) { 
        interval.connect()
    }
    
    let disposeBag = DisposeBag()
    delay(delay: 4) { 
        _ = interval
            .debug("2nd")
            .subscribe({ _ in })
            .disposed(by: disposeBag)
    }
}

//sampleWithPublish()

exampleOf("resourceCount") { 
    print(RxSwift.Resources.total)
    
    let disposeBag = DisposeBag()
    
    print(RxSwift.Resources.total)
    
    let observable = Observable.just("Hello, world!")
    
    print(RxSwift.Resources.total)
    
    observable
        .subscribe(onNext: { _ in
            print(RxSwift.Resources.total)
        })
    .disposed(by: disposeBag)
    
    print(RxSwift.Resources.total)
    
    
}

print(RxSwift.Resources.total)
