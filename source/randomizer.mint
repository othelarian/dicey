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

  fun randBase (factor : Number) : Number {
    Math.random() * factor
      |> Math.ceil()
   }
}