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

  // == another way
  _ = Observable.combineLatest([left, right]) {
    strings in strings.joined(separator: " ")
  }


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

example(of: "combine user choice and value") {
  let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
  let dates = Observable.of(Date())

  let observable = Observable.combineLatest(choice, dates) { format, when -> String in
    let formatter = DateFormatter()
    formatter.dateStyle = format
    return formatter.string(from: when)
  }

  _ = observable.subscribe(onNext: { print($0) })
}

example(of: "zip") {
  enum Weather {
    case sunny, cloudy
  }

  let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
  let right = Observable.of("Libon", "Copenhagen", "London", "Madrid", "Vienna")

  let observable = Observable.zip(left, right) { weather, city in
    return "It's \(weather) in \(city)"
  }

  _ = observable.subscribe(onNext: { print($0) })
}

example(of: "with latest from") {
  let button = PublishSubject<Void>()
  let textField = PublishSubject<String>()

  let observable = button.withLatestFrom(textField)
  _ = observable.subscribe(onNext: { print($0) })

  textField.onNext("Par")
  textField.onNext("Pari")
  textField.onNext("Paris")
  button.onNext(())
  button.onNext(())
}

example(of: "sample") {
  let button = PublishSubject<Void>()
  let textField = PublishSubject<String>()

  let observable = textField.sample(button)
  _ = observable.subscribe(onNext: { print($0) })

  textField.onNext("Par")
  textField.onNext("Pari")
  textField.onNext("Paris")
  button.onNext(())
  button.onNext(())
}

example(of: "amb") {
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()

  let observable = left.amb(right)
  _ = observable.subscribe(onNext: { print($0) })

  left.onNext("Lisbon")
  right.onNext("Copenhagen")
  left.onNext("London")
  left.onNext("Madrid")
  right.onNext("Vienna")
  left.onCompleted()
  right.onCompleted()
}

example(of: "switch latest") {
  let one = PublishSubject<String>()
  let two = PublishSubject<String>()
  let three = PublishSubject<String>()

  let source = PublishSubject<Observable<String>>()
  let observable = source.switchLatest()
  let disposable = observable.subscribe(onNext: { print($0) })

  source.onNext(one)
  one.onNext("Some text from sequence one")
  two.onNext("Some text from sequence two")
  source.onNext(two)
  two.onNext("More text from sequence two")
  one.onNext("and also from sequence one")
  source.onNext(three)
  two.onNext("Why don't you see me?")
  one.onNext("I'm alone, help me")
  three.onNext("Hey it's three. I win.")
  source.onNext(one)
  one.onNext("Nope. It's me, one!")

  disposable.dispose()
}

example(of: "reduce") {
  let source = Observable.of(1, 3, 5, 7, 9)

  //1
  let observable = source.reduce(0, accumulator: (+))
  _ = observable.subscribe(onNext: { print($0) })

  //2
  let observable2 = source.reduce(0) { summary, newValue in
    return summary + newValue
  }

  _ = observable2.subscribe(onNext: { print($0) })
}

example(of: "scan") {
  let source = Observable.of(1, 3, 5, 7, 9)
  let observable = source.scan(0, accumulator: +)
  _ = observable.subscribe(onNext: { print($0) })
}

example(of: "scan and zip") {
  let source = Observable.of(1, 3, 5, 7, 9)
  let observableScan = source.scan(0, accumulator: +)
  let observableZip = Observable.zip(source, observableScan) { value, total in
    return "The value is \(value) and the current total is \(total)"
  }
  _ = observableZip.subscribe(onNext: { print($0) })
}

example(of: "just scan and touple to show current values") {
  let source = Observable.of(1, 3, 5, 7, 9)
  let observable = source.scan((0, 0)) { acc, current in
    return (current, acc.0 + current)
  }

  _ = observable.subscribe(onNext: { tuple in
    print("Value = \(tuple.0)   Running total = \(tuple.1)")
  })
}
