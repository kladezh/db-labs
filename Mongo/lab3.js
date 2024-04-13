// Импортируем библиотеку для генерации ObjectId
import { ObjectId } from 'mongodb';

db.createCollection('products')
db.createCollection('users')
db.createCollection('reviews')
db.createCollection('categories')
db.createCollection('orders')

// Товары
db.products.insertOne({
    _id: ObjectId('615ae88b16248152f0a29bfa'),
    slug: 'gloves-1234',
    sku: '1234',
    name: 'Warm Winter Gloves',
    description: 'Comfortable and warm gloves for cold weather.',
    details: {
        weight: 0.2,
        weight_units: 'lbs',
        model_num: 987654321,
        manufactured: 'WarmCo',
        color: 'black',
    },
    total_reviews: 2,
    average_review: 4.0,
    pricing: {
        retail: 1999,
        sale: 1499,
    },
    pricing_history: [
        {
            retail: 1999,
            sale: 1499,
            start: new Date(2023, 1, 1),
            end: new Date(2023, 1, 31),
        }
    ],
    category_ids: [
        ObjectId('615ae8a216248152f0a29bfb'),
    ],
    main_cat_id: ObjectId('615ae8a216248152f0a29bfb'),
    tags: [
        'clothing',
        'winter',
        'accessories',
    ]
});

db.products.insertOne({
    _id: ObjectId('615ae88b16248152f0a29bfb'),
    slug: 'pants-5678',
    sku: '5678',
    name: 'Stylish Winter Pants',
    description: 'Stylish and comfortable pants for the winter season.',
    details: {
        weight: 0.8,
        weight_units: 'lbs',
        model_num: 123456789,
        manufactured: 'WarmCo',
        color: 'blue',
    },
    total_reviews: 4,
    average_review: 4.5,
    pricing: {
        retail: 2999,
        sale: 2499,
    },
    pricing_history: [
        {
            retail: 2999,
            sale: 2499,
            start: new Date(2023, 1, 1),
            end: new Date(2023, 1, 31),
        }
    ],
    category_ids: [
        ObjectId('615ae8a216248152f0a29bfc'),
    ],
    main_cat_id: ObjectId('615ae8a216248152f0a29bfc'),
    tags: [
        'clothing',
        'winter',
        'bottoms',
    ]
});


// Пользователи
db.users.insertOne({
    _id: ObjectId('615ae8b216248152f0a29bfc'),
    username: 'johndoe',
    email: 'johndoe@example.com',
    first_name: 'John',
    last_name: 'Doe',
    hashed_password: 'hashedpassword123',
    addresses: [
        {
            name: 'home',
            street: '123 Main St',
            city: 'Anytown',
            state: 'NY',
            zip: 12345,
        },
    ],
    payment_methods: [
        {
            name: 'Mastercard',
            last_four: 5678,
            crypted_name: 'cryptedname123',
            expiration_date: new Date(2025, 12),
        }
    ],
});

db.users.insertOne({
    _id: ObjectId('66106977b0f783eca8c7e31d'),
    username: 'maxpayne',
    email: 'supermax@example.com',
    first_name: 'Max',
    last_name: 'Payne',
    hashed_password: 'anotherhashedpassword456',
    addresses: [
        {
            name: 'work',
            street: '456 Elm St',
            city: 'Sometown',
            state: 'CA',
            zip: 54321,
        },
    ],
    payment_methods: [
        {
            name: 'Visa',
            last_four: 1234,
            crypted_name: 'anothercryptedname789',
            expiration_date: new Date(2026, 6),
        }
    ],
});


// Отзывы
db.reviews.insertOne({
    _id: ObjectId('615ae8c216248152f0a29bfd'),
    product_id: ObjectId('615ae88b16248152f0a29bfa'),
    date: new Date(2024, 2, 15),
    title: 'Great gloves!',
    text: 'These gloves kept my hands warm even in freezing temperatures. Highly recommend!',
    rating: 5,
    user_id: ObjectId('615ae8b216248152f0a29bfc'),
    username: 'johndoe',
    helpful_votes: 0,
    voter_ids: [
    ]
});

// Категории
db.categories.insertOne({
    name: 'home',
    _id: ObjectId('615ae8d316248152f0a28bff'),
    slug: 'home',
    description: 'Caterogory for home products.',
});

db.categories.insertOne({
    _id: ObjectId('615ae8d316248152f0a29bfe'),
    slug: 'winter-clothing',
    name: 'Winter Clothing',
    description: 'Clothing for cold weather conditions.',
    ancestors: [
        {
          name: 'home',
          _id: ObjectId('615ae8d316248152f0a28bff'),
          slug: 'home'
        }
    ],
});


// Заказы
db.orders.insertOne({
    _id: ObjectId('615ae8e216248152f0a29c00'),
    user_id: ObjectId('615ae8b216248152f0a29bfc'),
    state: 'CART',
    line_items: [
        {
            _id: ObjectId('615ae8e216248152f0a29c01'),
            sku: '1234',
            name: 'Warm Winter Gloves',
            quantity: 1,
            pricing: {
                retail: 1999,
                sale: 1499,
            },
        },
    ],
    shipping_address: {
        street: '456 Elm St',
        city: 'Othertown',
        state: 'CA',
        zip: 67890,
    },
});


// ---------------------------------------------------------------------------------------

// 1. Обновить  почтовый индекс пользователя модификацией замены
db.users.find()

let user = db.users.findOne({ username: 'johndoe' });
let address = user.addresses.find(addr => addr.name === 'home');

address.zip = '20020';

db.users.replaceOne(
    { username: 'johndoe' },
    user
)


// 2. Обновить электронный адрес пользователя путем направленного обновления
db.users.updateOne(
    { username: 'johndoe' },
    { $set: { email: "newadress@mail.ru" } }
)


db.users.find()

// 3. Добавить новый адрес в список адресов  путем замены документа

// Найдем пользователя по его имени
let user = db.users.findOne({ username: 'johndoe' });

// Добавим новый адрес в список адресов
let newAddress = {
    name: "Office",
    street: "Prigozhina",
    city: "Night City",
    state: "FFS",
    zip: "67849"
};

// Добавим новый адрес в список адресов пользователя
user.addresses.push(newAddress);

// Теперь заменим существующий документ пользователя обновленным
db.users.replaceOne(
    { username: 'johndoe' },
    user
);


// 4. Добавить новый адрес в список адресов  путем направленного обновления
db.users.updateOne(
    { username: 'johndoe' },
    { $push: { addresses: 
        {
            name: "School",
            street: "Zamay",
            city: "Novigrad",
            state: "Velen",
            zip: "21523"
        } 
    } }
);


// 5. Обновить средний рейтинг товара при добавлении отзыва

// Для решения нужно:
// 1) Найти товар по его идентификатору.
// 2) Получить существующий средний рейтинг и общее количество отзывов.
// 3) Посчитать новый средний рейтинг, учитывая новый отзыв.
// 4) Обновить документ товара с новым средним рейтингом и общим количеством отзывов.

// Найдем товар по его _id
let product = db.products.findOne({ slug: 'gloves-1234' });

let averageRating = (product.total_reviews * product.average_review) / 10;

// Обновим документ товара с новым средним рейтингом и общим количеством отзывов
db.products.updateOne(
    { slug: 'gloves-1234' },
    { $set: { 
        total_reviews: totalReviews, 
        average_rating: averageRating 
    } }
);


// 6. Обновить название категории, включая документы – потомки
function updateCategory(categoryName, newCategoryName) {
    db.categories.updateOne(
        { name: categoryName },
        { $set: { name:newCategoryName } }
    );

    db.categories.updateMany(
        { "ancestors.name": categoryName },
        { $set: { "ancestors.$.name": newCategoryName } }
    );
}

// Пример вызова функции для обновления категории
updateCategory('home', "drom");


// 7. Обновить информацию  об общем количестве голосов при добавлении нового проголосовавшего. 
// Учесть его голос в том случае, если он раньше не голосовал

let userId = db.users.findOne({ username: 'maxpayne'})._id;

let reviewTitle = 'Great gloves!';

let votedBefore = db.reviews.findOne({ title: reviewTitle, voter_ids: userId });

// Определим, какое действие нужно выполнить в зависимости от того, голосовал ли пользователь ранее
if (votedBefore) {
    // Если пользователь уже голосовал, просто увеличим общее количество голосов
    db.reviews.updateOne(
        { title: reviewTitle },
        { $inc: { helpful_votes: 1 } }
    );
} else {
    // Если пользователь еще не голосовал, добавим его голос в список и увеличим общее количество голосов
    db.reviews.updateOne(
        { title: reviewTitle },
        { 
            $addToSet: { voter_ids: userId },
            $inc: { helpful_votes: 1 }
        }
    );
}


// 8. Обновить документ  с данным заказом, добавив новый товар, изменив общую сумму, 
// добавить еще одну позицию товара из корзины

function addProductToOrder(orderId, productId) {
    let product = db.products.findOne({ _id: productId });
    let order = db.orders.findOne({ _id: orderId });

    // проверяем, был ли добавлен такой товар
    let addedProduct = order.line_items.find(prod => prod._id.equals(productId));
    if (addedProduct) { // если да, то увеличиваем его кол-во
        addedProduct.quantity++;
    } else { // иначе, добавляем его необходимую информацию
        order.line_items.push({
            _id: product._id,
            sku: product.sku,
            name: product.name,
            quantity: 1,
            pricing: product.pricing
        })
    }

    // изменяем общую сумму
    let total = 0;
    order.line_items.forEach(item => {
        total += item.pricing.sale * item.quantity;
    });
    order.total = total;
    
    // обновляем заказ в базе
    db.orders.updateOne(
        { _id: orderId },
        { $set: order }
    );
}

// добавляем в заказ товар "штаны"
addProductToOrder(
    orderId=ObjectId('615ae8e216248152f0a29c00'), 
    productId=ObjectId('615ae88b16248152f0a29bfb')
);


// 9. Перевести заказ из состояния "Корзина" в состояние "перед авторизацией"

// Найдем все заказы, находящиеся в состоянии "Корзина"
let ordersInCart = db.orders.find({ state: 'CART' });

// Обновим состояние найденных заказов на "перед авторизацией"
ordersInCart.forEach(order => {
    db.orders.updateOne(
        { _id: order._id },
        { $set: { state: 'BEFORE AUTH' } }
    );
});


// 10. Добавить новые категории для товара "перчатки" (или с другим названием)

function addCategoryToProduct(categoryId, productId) {
    let product = db.products.findOne({ _id: productId })

    if (!product.category_ids.includes(categoryId)) {
        product.category_ids.push(categoryId);
    }

    db.products.updateOne(
        { _id: product._id },
        { $set: { category_ids: product.category_ids } }
    );
}

db.categories.insertOne({
    _id: ObjectId('615ae8d316248152f0a29bff'),
    slug: 'gloves',
    name: 'Gloves',
    description: 'Category for gloves of different types.',
});

let newCategory = db.categories.findOne({ slug: 'gloves' });
let productToUpdate = db.products.findOne({ slug: "gloves-1234" });

addCategoryToProduct(
    categoryId=newCategory._id, 
    productId=productToUpdate._id
)


// 11. Удалить одну заданную категорию для заданного  товара

function removeCategoryFromProduct(categoryId, productId) {
    // Проверяем, существует ли товар и категория в базе данных
    let product = db.products.findOne({ _id: productId });
    if (!product) {
        print(`Товар с id (${productId}) не найден.`);
        return;
    }

    let removedCategory = db.categories.findOne({ _id: categoryId });
    if (!removedCategory) {
        print(`Категория с id (${categoryId}) не найдена.`);
        return;
    }

    // Ищем индекс категории в массиве

    let index = -1;
    for (let i = 0; i < product.category_ids.length; i++) {
        if (product.category_ids[i].equals(categoryId)) {
            index = i;
        }
    }

    if (index !== -1) {
        // Удаляем категорию из массива
        product.category_ids.splice(index, 1);
        
        db.products.updateOne(
            { _id: product._id },
            { $set: { category_ids: product.category_ids } }
        );
    } else {
        print(`Категория с id (${categoryId}) не найдена в товаре с id (${productId}.)`);
    }
}

let removedCategory = db.categories.findOne({ slug: 'gloves' });
let productToUpdate = db.products.findOne({ slug: "gloves-1234" });

removeCategoryFromProduct(
    categoryId=removedCategory._id, 
    productId=productToUpdate._id
)


// 12. Изменить количество товара с заданным номером  в заказе на 5шт

function changeProductQuantityInOrder(orderId, productId, quantity) {
    let product = db.products.findOne({ _id: productId });
    let order = db.orders.findOne({ _id: orderId });

    let productToUpdate = order.line_items.find(prod => prod._id.equals(productId));
    if (productToUpdate) {
        productToUpdate.quantity = quantity;

        db.orders.updateOne(
            { _id: order._id },
            { $set: { line_items: order.line_items } }
        );
    }
}

let order = db.orders.findOne({ _id: ObjectId('615ae8e216248152f0a29c00') });
let product= db.products.findOne({ slug: "gloves-1234" });

changeProductQuantityInOrder(order._id, product._id, 5);


// 13. Удалить отзывы конкретного пользователя

let user = db.users.findOne({ username: 'johndoe' });

db.reviews.deleteMany({ user_id: user._id });


// 14. Создать разреженный индекс по полю sku

// Создание разреженного индекса по полю "sku" в коллекции "products"
db.products.createIndex({ sku: 1 }, { sparse: true });

// Проверка создания индекса
db.products.getIndexes();