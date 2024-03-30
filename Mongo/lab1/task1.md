## Лаба 1

Перейти в базу данных `lab1` (если она не создана, то создастся автоматически).
```js
use lab1
```

```js
db.users // обращение к коллекции `users`, создавать её вручную необязательно.
```

Вставить в коллекцию несколько документов (`inserOne()` - вставить один документ).
```js
db.users.insertMany([
    { name: "john" }, 
    { name: "smith" },
])
```

Вывести кол-во документов в коллекции.
```js
db.users.count()
```

Вывести все документы из коллекции.
```js
db.users.find()
```

Вывести документы с именем *"john"* из коллекции
```js
db.users.find({name: "john"})
```

Обновить документы в коллекции, у которых имя = *"smith"*. Свойство `$set` добавляет к документы переданные данные.
```js
db.users.updateOne({name: "smith"}, {
    $set: {
        country: "canada"
    }
})
```

```js
db.users.updateOne({name: "smith"}, {
    $set: {
        favorities: {
            cities: ["chicago", "rome"], 
            movies: ["matrix", "the sting"]
        }
    }
})
```

Обновить документы в коллекции, у которых `name` = `"smith"`. Свойство `$unset` удаляет переданные аттрибуты (в качестве значения аттрибута можно передать что угодно).
```js
db.users.updateOne({name: "smith"}, {
    $unset: {
        country: 1
    }
})
```

Обновить документы в коллекции, у которых `name` = `"john"`. Свойство `$set` добавляет к документы переданные данные.
```js
db.users.updateOne({name: "john"}, {
    $set: {
        favorities: {
            movies: ["rocky", "winter"]
        }
    }
})
```

Найти документы в коллекции, у которых в аттрибуте `favorites` в значении массива `movies` содержится `"matrix"`
```js
db.users.find({"favorities.movies": "matrix"})
```

Обновить документы в коллекции, у которых в аттрибуте `favorites` в значении массива `movies` содержится `"matrix"`. Свойство `$addToSet` добаляет к ключу новые значения (в данном случае, в массив `favorities.movies` добавляется `"matrix2"`).
```js
db.users.update({"favorities.movies": "matrix"}, {
    $addToSet: {
        "favorities.movies": "matrix2"
    }
}, false,true)
```

Удалить из коллекции документ, в котором ключ `favorities.cities` содержит `"rome"`.
```js
db.users.remove({"favorities.cities": "rome"})
```

Создать коллекцию `numbers`.
```js
db.createCollection("numbers")
```

Перейти в коллекцию `numbers`.
```js
use numbers
```

Сформировать массив из 200 тыс. чисел, передать его в переменную `docs` и вставить в коллекцию `numbers` документы, где каждый будет хранить значение числа.
```js
var docs = [];
for(i=0; i<200000; i++) { 
    docs.push({num: i});
}
db.numbers.insertMany(docs);
```

Вывести кол-во всех документов из коллекции `numbers`.
```js
db.numbers.count()
```

Вывести документы из коллекции `numbers`, в которых `num` = `500`
```js
db.numbers.find({num: 500})
```

Вывести документы из коллекции `numbers`, в которых `num` больше чем `199995`.

- `$gt` - больше чем (greater than)
- `$lt` - меньше чем (less than)
- `$gte` - больше или равно чем (greater than equal)
- `$lte` - меньше или равно чем (less than equal)

```js
db.numbers.find({num: {$gt: 199995} })
```

Вывести документы из коллекции `numbers`, в которых `num` больше чем `20` и меньше чем `25`.
```js
db.numbers.find({num: {$gt: 20, $lt: 25} })
```

Вывести документы из коллекции `numbers`, в которых `num` больше чем `199995`. Вывести статистику о запросе.
```js
db.numbers.find({num: {$gt: 199995} }).explain()
```

Создать индекс для документа в коллекции `numbers`.
```js
db.numbers.ensureIndex({num: 1})
```

Вывести все индексы для коллекции `numbers`.
```js
db.numbers.getIndexes()
```

Вывести все базы данных (сокращение от `show databases`).
```js
show dbs
```

Вывести все коллекции в текущей базе.
```js
show collections
```

Вывести статистику базы.
```js
db.stats()
```

Вывести доступные команды базы.
```js
db.help()
```

Вывести доступные команды для коллекции `users`.
```js
db.users.help()
```

Вставить в коллекцию `users` один документ.
```js
db.users.insertOne({
    name: "tom", 
    age: 28, 
    languages: ["english", "german"]
})
```

Вставить в коллекцию `users` один документ, но значения передать через переменную.
```js
var doc = ({
    name: "bill", 
    age: 32, 
    languages: ["english", "french"]
});
db.users.insertOne(doc);
```

Создать коллекцию со своей настройкой:

- `capped: true` - фиксированная коллекция, которая не меняет размера
- `size: 500` - размер коллекции = 500 байт
- `max: 150` - максимальное кол-во документов = 150

```js
db.createCollection("profile", {capped: true, size: 500, max: 150})
```

Вывести статистику профайлера базы (профайлер собирают информацию об операциях).
```js
db.profile.stats()
```

Вставить в коллекцию `users` один документ.
```js
db.users.insertOne({
    name: "tom", 
    age: 32,
    languages: ["english"]
})
```

Вывести из коллекции `users` документ, у которого `name` = `"tom"`
```js
db.users.find({name: "tom"})
```

Вывести из коллекции `users` документ, у которого `languages` содержит `"german"`
```js
db.users.find({languages: "german"})
```

Вывести из коллекции `users` документ, у которого `name` = `"tom"` и `age` = `32`.
```js
db.users.find({name: "tom", age: 32})
```

Вывести из коллекции `users` документ, у которого `name` = `"tom"`. Вывести только аттрибуты `name` и `age` (и `_id` по умолчанию).
```js
db.users.find({name: "tom"}, {age: 1})
```

Вывести из коллекции `users` документ, у которого `name` = `"tom"`. Вывести только аттрибуты `name` и `age`.
```js
db.users.find({name: "tom"}, {age: true, _id: false})
```
