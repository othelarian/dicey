enum DieType {
  Dn(Number)
}

module Randomizer {
  fun dieToStr (dt : DieType) : String { case (dt) {
    DieType::Dn n => "d" + Number.toString(n)
  }}

  fun dieToValue (dt : DieType) : String { case (dt) {
    DieType::Dn n => Number.toString(randBase(n))
  }}

  fun newKey : String {
    Array.range(0, 14)
      |> Array.reduce("", (r : String, i : Number) { r + randy()})
  } where {
    stock = "abcdefghijkmlnopqrtsuvwxyz0312456789ABCDEFGHIJKLMNOPQRSTUVWXYZ;?,/:-_&()[]{}"
    randy = () {
      String.toArray(stock)
        |> Array.at(Math.floor(Math.random() * String.size(stock)))
        |> Maybe.withDefault("")
    }
  }

  fun randBase (factor : Number) : Number {
    Math.random() * factor
      |> Math.ceil()
   }
}