import Foundation
import PlaygroundSupport
import RxSwift

PlaygroundPage.current.needsIndefiniteExecution = true


example(of: "start with") {
  let numbers = Observable.of("2","3","4")
  let observable = numbers.startWith("1")
  _ = observable
    .subscribe(onNext: { print($0) })
}

example(of: "observable.concat") {
  let first = Observable.of(1, 2, 3)
  let second = Observable.of(4, 5, 6)

  let observable = Observable.concat([first, second])

  observable.subscribe(onNext: { print($0) })
}

example(of: "concat") {
  let germanCities = Observable.of("Berlim", "Munich", "Frankfurt")
  let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")

  let observable = germanCities.concat(spanishCities)
  _ = observable.subscribe(onNext:{ print($0) })
}

example(of: "concat map") {
  let sequences = [
    "German cities": Observable.of("Berlin", "Munich", "Frankfurt"),
    "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
  ]

  let observable = Observable.of("German cities", "Spanish cities")
    .concatMap { country in sequences[country] ?? .empty() }

  _ = observable.subscribe(onNext:{ print($0) })
}

example(of: "merge") {
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()

  let source = Observable.of(left.asObservable(), right.asObservable())

  let observable = source.merge()
  _ = observable.subscribe(onNext: { print($0) })

  var leftValues = ["Berlin", "Munich", "Frankfurt"]
  var rightValues = ["Madrid", "Barcelona", "Valencia"]

  repeat {
    switch Bool.random() {
    case true where !leftValues.isEmpty:
      left.onNext("Left: \(leftValues.removeFirst())")
    case false where !rightValues.isEmpty:
      right.onNext("Right: \(rightValues.removeFirst())")
    default:
      break
    }
  } while !leftValues.isEmpty || !rightValues.isEmpty

  left.onCompleted()
  right.onCompleted()
}

example(of: "combine latest") {
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()
  let number = PublishSubject<Int>()

  let observable = Observable.combineLatest(left, right, number) {
    lastLeft, lastRight, number in
      "\(lastLeft) \(lastRight) \(number)"
  }

  _ = observable.subscribe(onNext: { print($0) })

  print("> Sending a value to Left")
  left.onNext("Hello,")
  number.onNext(1)
  print("> Sending a value to Right")
  right.onNext("world")
  print("> Sending another value to Right")
  right.onNext("RxSwift")
  print("> Sending another value to Left")
  left.onNext("Have a good day,")

  left.onCompleted()
  right.onCompleted()
}





