# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
comedy = Category.create!(name: 'Comedy')
drama = Category.create!(name: 'Drama')
horror = Category.create!(name: 'Horror')
documentary = Category.create!(name: 'Documentary')

big_bang = Video.create!(title: 'Big Bang Theory',
  description: "Mensa-fied best friends and roommates Leonard and Sheldon, physicists who work at the California Institute of Technology, may be able to tell everybody more than they want to know about quantum physics, but getting through most basic social situations, especially ones involving women, totally baffles them.",
  small_cover: '/tmp/big_bang_sm.jpg', 
  large_cover: '/tmp/big_bang_lg.jpg',
  category: comedy,
)

hell = Video.create!(title: 'Hell on Wheels',
  description: "The Civil War is in the past, but former Confederate soldier Cullen Bohannon can't put it behind him. Fresh are the horrific memories of the death of his wife, killed at the hands of the Union soldiers, an act that sets Bohannon on a course of revenge. This contemporary Western tells the story of his journey, a story that rides on Union Pacific's construction of the first transcontinental railroad.",
  small_cover: '/tmp/hell_wheels_sm.jpg', 
  large_cover: '/tmp/hell_wheels_lg.jpg',
  category: drama,
)

new_girl = Video.create!(title: 'New Girl',
  description: "After going through a rough breakup, awkward and upbeat Jess (Zooey Deschanel) moves in with three single guys. Intelligent and witty Nick is an underachiever who took the bartender off-ramp on his road to success. Schmidt obsesses over his social standing and looks at Jess as a personal project. Winston is a competitive former athlete who, after realizing he will never become a pro, moves into the loft. Together with Jess' best friend, Cece, they bond to form an unlikely, and dysfunctional, family.",
  small_cover: '/tmp/new_girl_sm.jpg', 
  large_cover: '/tmp/new_girl_lg.jpg',
  category: comedy,
)

dr_who = Video.create!(title: 'Doctor Who',
  description: "An eccentric yet compassionate extraterrestrial Time Lord zips through time and space to solve problems and battle injustice across the universe, traveling via the TARDIS (Time and Relative Dimensions in Space), which is his old and occasionally unreliable spaceship that resembles a blue police phone box (but changes its appearance depending on its surroundings) and is much, much larger inside than outside.",
  small_cover: '/tmp/dr_who_sm.jpg', 
  large_cover: '/tmp/dr_who_lg.jpg',
  category: drama,
)

shield = Video.create!(title: 'Agents of S.H.I.E.L.D.',
  description: "Phil Coulson (Clark Gregg) heads an elite team of fellow agents with the worldwide law-enforcement organization known as SHIELD (Strategic Homeland Intervention Enforcement and Logistics Division), as they investigate strange occurrences around the globe. Its members -- each of whom brings a specialty to the group -- work with Coulson to protect those who cannot protect themselves from extraordinary and inconceivable threats, including a formidable group known as Hydra.",
  small_cover: '/tmp/shield_sm.jpg', 
  large_cover: '/tmp/shield_lg.jpg',
  category: drama,
)

Video.create!(title: 'Big Bang Theory 2',
  description: "Mensa-fied best friends and roommates Leonard and Sheldon, physicists who work at the California Institute of Technology, may be able to tell everybody more than they want to know about quantum physics, but getting through most basic social situations, especially ones involving women, totally baffles them.",
  small_cover: '/tmp/big_bang_sm.jpg', 
  large_cover: '/tmp/big_bang_lg.jpg',
  category: comedy,
)

Video.create!(title: 'Hell on Wheels 2',
  description: "The Civil War is in the past, but former Confederate soldier Cullen Bohannon can't put it behind him. Fresh are the horrific memories of the death of his wife, killed at the hands of the Union soldiers, an act that sets Bohannon on a course of revenge. This contemporary Western tells the story of his journey, a story that rides on Union Pacific's construction of the first transcontinental railroad.",
  small_cover: '/tmp/hell_wheels_sm.jpg', 
  large_cover: '/tmp/hell_wheels_lg.jpg',
  category: drama,
)

Video.create!(title: 'New Girl 2',
  description: "After going through a rough breakup, awkward and upbeat Jess (Zooey Deschanel) moves in with three single guys. Intelligent and witty Nick is an underachiever who took the bartender off-ramp on his road to success. Schmidt obsesses over his social standing and looks at Jess as a personal project. Winston is a competitive former athlete who, after realizing he will never become a pro, moves into the loft. Together with Jess' best friend, Cece, they bond to form an unlikely, and dysfunctional, family.",
  small_cover: '/tmp/new_girl_sm.jpg', 
  large_cover: '/tmp/new_girl_lg.jpg',
  category: comedy,
)

Video.create!(title: 'Doctor Who 2',
  description: "An eccentric yet compassionate extraterrestrial Time Lord zips through time and space to solve problems and battle injustice across the universe, traveling via the TARDIS (Time and Relative Dimensions in Space), which is his old and occasionally unreliable spaceship that resembles a blue police phone box (but changes its appearance depending on its surroundings) and is much, much larger inside than outside.",
  small_cover: '/tmp/dr_who_sm.jpg', 
  large_cover: '/tmp/dr_who_lg.jpg',
  category: drama,
)

Video.create!(title: 'Agents of S.H.I.E.L.D. 2',
  description: "Phil Coulson (Clark Gregg) heads an elite team of fellow agents with the worldwide law-enforcement organization known as SHIELD (Strategic Homeland Intervention Enforcement and Logistics Division), as they investigate strange occurrences around the globe. Its members -- each of whom brings a specialty to the group -- work with Coulson to protect those who cannot protect themselves from extraordinary and inconceivable threats, including a formidable group known as Hydra.",
  small_cover: '/tmp/shield_sm.jpg', 
  large_cover: '/tmp/shield_lg.jpg',
  category: drama,
)

Video.create!(title: 'Doctor Who 3',
  description: "An eccentric yet compassionate extraterrestrial Time Lord zips through time and space to solve problems and battle injustice across the universe, traveling via the TARDIS (Time and Relative Dimensions in Space), which is his old and occasionally unreliable spaceship that resembles a blue police phone box (but changes its appearance depending on its surroundings) and is much, much larger inside than outside.",
  small_cover: '/tmp/dr_who_sm.jpg', 
  large_cover: '/tmp/dr_who_lg.jpg',
  category: drama,
)

bob = User.create!(name: "Bob", email: "bob@example.com", password: "password")
thadeus = User.create!(name: "Thadeus", email: "thadeus@example.com", password: "password")
antilles = User.create!(name: "Antilles", email: "antilles@example.com", password: "password")

Review.create!(user: bob, rating: 2, video: new_girl , comment: "This show is terrible.")
Review.create!(user: thadeus, rating: 5, video: new_girl , comment: "This show is awesome.")
Review.create!(user: antilles, rating: 2, video: shield , comment: "This show is terrible.")
Review.create!(user: bob, rating: 4, video: shield , comment: "This show is awesome.")
Review.create!(user: bob, rating: 2, video: hell , comment: "This show is terrible.")
Review.create!(user: thadeus, rating: 3, video: hell , comment: "This show is awesome.")
Review.create!(user: antilles, rating: 2, video: big_bang , comment: "This show is terrible.")
Review.create!(user: bob, rating: 5, video: big_bang , comment: "This show is awesome.")
Review.create!(user: thadeus, rating: 1, video: dr_who , comment: "This show is terrible.")
Review.create!(user: antilles, rating: 5, video: dr_who , comment: "This show is awesome.")
