use tasks1

db.users.insertMany([{name:"john"}, {name: "smith"}])
db.users.count()
db.users.find()
db.users.find({name:"john"})

db.users.updateOne({name:"smith"}, {$set:{country:"canada"}})
db.users.updateOne({name:"smith"}, {$set:{favorities:{cities:["chicago", "rome"], movies:["matrix", "the sting"]}}})
db.users.updateOne({name:"smith"}, {$unset:{country:1}})
db.users.updateOne({name:"john"}, {$set:{favorities:{movies:["rocky", "winter"]}}})

db.users.find({"favorities.movies": "matrix"})
db.users.update({"favorities.movies": "matrix"}, {$addToSet:{"favorities.movies": "matrix2"}}, false,true)
db.users.remove({"favorities.cities": "rome"})


db.createCollection("numbers")

var docs = [];
for(i=0; i<200000; i++) { 
    docs.push({num: i});
}
db.numbers.insertMany(docs);

db.numbers.count()

db.numbers.find({num:500})
db.numbers.find({num:{$gt:199995}})
db.numbers.find({num:{$gt :20, $lt: 25}})

db.numbers.find({num:{$gt:199995}}).explain()
db.numbers.ensureIndex({num:1})
db.numbers.getIndexes()


show dbs
show collections
db.stats()
db.help()
db.users.help()


db.users.insertOne({name:"tom", age:28, languages:["english", "german"]})

document=({name:"bill", age:32, languages:["english", "french"]})
db.users.insertOne(document)

db.createCollection("profile",{capped:true, size:500, max:150})
db.profile.stats()

db.users.insertOne({name:"tom", age:32,languages:["english"]})
db.users.find({name:"tom"})
db.users.find({languages:"german"})
db.users.find({name:"tom", age:32})
db.users.find({name:"tom"},{age: true})
db.users.find({name:"tom"},{age: true, _id: false})
