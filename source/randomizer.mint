enum DieType {
  D4
  D6
  D8
}

module Randomizer {
  fun dieToStr (dt : DieType) : String { case (dt) {
    DieType::D4 => "d4"
    DieType::D6 => "d6"
    DieType::D8 => "d8"
  }}

  fun dieToValue (dt : DieType) : String { case (dt) {
    DieType::D4 => Number.toString(randBase(4))
    DieType::D6 => Number.toString(randBase(6))
    DieType::D8 => Number.toString(randBase(8))
  }}

  fun newKey : String {
    Debug.log("new key")
  } where {
    stock = "abcdefghijkmlnopqrtsuvwxyz0312456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  }

  fun randBase (factor : Number) : Number {
    Math.random() * factor
      |> Math.ceil()
   }
}