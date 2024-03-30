db.users.insertOne({
    name: "alex",
    age: 28,
    company: {
        name: "microsoft",
        country: "usa"
    }
})

db.users.find().limit(3)

db.users.find().skip(2)

db.users.find().sort({ name: 1 })
db.users.find().sort({ name: 1 }).skip(1).limit(3)
db.users.find().sort({ $natural: -1 }).limit(3)

db.users.find({ name: "tom" }, { 
    languages: { $slice: 1 } 
})
db.users.find({ name: "tom" }, { 
    languages: { $slice: [-1, 1] } 
})

db.users.find({}, { name: 1 })

db.users.find({ name: "tom" }).count()

db.users.find({ name: "tom" }).skip(2).count()

db.users.distinct("name")

db.profile.deleteMany({})
db.profile.drop()

db.users.find({ age: { $ne: 22 } }) // не равно
db.users.find({ age: { $in: [22, 32] } }) // в пределах
db.users.find({ age: { $nin: [22, 32] } }) // не в пределах

db.users.find({ languages: { $all: ["english", "french"] } })

db.users.find({ $or: [{ name: "tom" }, { age: 32 }] })

db.users.find({ name: "tom", $or: [{ age: 32 }, { languages: "french" }] })

db.users.find({ languages: { $size: 2 } })

db.users.find({ company: { $exists: true } })

db.users.find({ name: { $regex: "^b" } })

db.users.insertOne({ 
    name: "eugene", 
    age: 29, 
    languages: ["english", "spanish", "french"] 
})

db.users.updateOne({ name: "tom" }, { 
    $set: { 
        name: "tom", 
        age: 25, 
        married: false 
    } 
}, 
{
    upsert: true 
}
)

db.users.updateOne({ name: "eugene", age: 29 }, { 
    $set: { 
        age: 30 
    } 
})
db.users.updateOne({ name: "tom" }, { 
    $set: { 
        name: "tom", 
        age: 25, 
        married: false 
    } 
}, 
{
    multi: true 
})
db.users.updateOne({ name: "tom" }, { 
    $inc: { 
        salary: 100 
    } 
})
db.users.updateOne({ name: "tom" }, { 
    $unset: { 
        salary: 1 
    } 
})
db.users.updateOne({ name: "tom" }, { 
    $unset: { 
        salary: 1, 
        age: 1 
    } 
})
db.users.updateOne({ name: "tom" }, { 
    $addToSet: { 
        languages: "spanish" 
    } 
})
db.users.updateOne({ name: "tom" }, { 
    $addToSet: { 
        languages: { 
            $each: ["russian", "italian"] 
        } 
    }
})
db.users.updateOne({ name: "tom" }, { 
    $pop: { 
        languages: -1 
    } 
})
db.users.updateOne({ name: "tom" }, { 
    $pull: { 
        languages: "english" 
    } 
})
db.users.updateOne({ name: "tom" }, { 
    $pull: { 
        languages: ["english", "french", "german"] 
    }
})

db.users.deleteMany({ age: { $lt: 30 } })