class Astrology < ApplicationRecord
  	enum sign: {
    "aries"=> 1,
    "taurus"=>2,
    "gemini"=>3,
    "cancer"=>4,
    "leo"=>5,
    "virgo"=>6,
    "libra"=>7,
    "scorpio"=>8,
    "sagittarius"=>9,
    "capricorn"=>10,
    "aquarius"=>11,
    "pisces"=>12
  }
end
