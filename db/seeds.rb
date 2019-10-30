User.destroy_all

#User.create!(username: "captainpike",
#            first_name: "Christopher",
#            last_name: "Pike",
#            email: "christopherpike@starfleet.com",
#            password: "chris1234",
#            password_confirmation: "chris1234",
#            admin: false,
#            queen: false,
#            activated: true,
#            activated_at: Time.zone.now)
#
#User.create!(username: "bettermidler",
#            first_name: "Better",
#            last_name: "Midler",
#            email: "better@midler.com",
#            password: "better1234",
#            password_confirmation: "better1234",
#            admin: true,
#            queen: true,
#            activated: true,
#            activated_at: Time.zone.now)
#
#User.create!(username: "hovabooboo",
#            first_name: "Hova",
#            last_name: "Harbison-Ortiz",
#            email: "hova@naughtydog.com",
#            password: "hova1234",
#            password_confirmation: "hova1234",
#            admin: false,
#            queen: false,
#            activated: true,
#            activated_at: Time.zone.now)
#
#User.create!(username: "alyssaedwards",
#            first_name: "Alyssa",
#            last_name: "Edwards",
#            email: "alyssa@edwards.com",
#            password: "alyssa1234",
#            password_confirmation: "alyssa1234",
#            admin: true,
#            queen: false,
#            activated: true,
#            activated_at: Time.zone.now)
#
#User.create!(username: "trinitythetuck",
#            first_name: "Trinity",
#            last_name: "TheTuck",
#            email: "trinity@thetuck.com",
#            password: "trinity1234",
#            password_confirmation: "trinity1234",
#            admin: false,
#            queen: true,
#            activated: true,
#            activated_at: Time.zone.now)

User.create!(username: "jaredharbison",
            first_name: "Jared",
            last_name: "Harbison",
            email: "jared.harbison@gmail.com",
            password: "jared1234",
            password_confirmation: "jared1234",
            admin: true,
            queen: false,
            activated: true,
            activated_at: Time.zone.now)

User.new.get_queens


################following relationships################
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
10.times { users.each { |user| Micropost.create(content: Faker::TvShows::RuPaul.quote, user_id: user.id)}}


################creating a user template################
#User.create!(username: "",
#            first_name: "",
#            last_name: "",
#            email: "",
#            password: "",
#            password_confirmation: "",
#            admin: ,
#            queen: ,
#            activated: true,
#            activated_at: Time.zone.now)
