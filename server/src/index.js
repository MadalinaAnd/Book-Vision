var koa = require('koa');
var app = module.exports = new koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server });
const Router = require('koa-router');
const cors = require('@koa/cors');
const bodyParser = require('koa-bodyparser');

app.use(bodyParser());

app.use(cors());

app.use(middleware);

function middleware(ctx, next) {
    const start = new Date();
    return next().then(() => {
        const ms = new Date() - start;
        console.log(`${start.toLocaleTimeString()} ${ctx.request.method} ${ctx.request.url} ${ctx.response.status} - ${ms}ms`);
    });
}


const getRandomInt = (min, max) => {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
};

const books = [];
const name = ['Name1', 'Name2', 'Name3'];
const author = ['Author1', 'Author2', 'Author3'];
const description = ['Description1', 'Description2', 'Description3'];
const numberPages = ['1', '2', '3'];
const genre = ['Genre1', 'Genre2', 'Genre3'];
const publishingHouse = ['PublishingHouse1', 'PublishingHouse2', 'PublishingHouse3'];

for (let i = 0; i < 3; i++) {
    books.push({
        id: i + 1,
        name: name[getRandomInt(0, name.length)],
        author: author[getRandomInt(0, author.length)],
        description: description[getRandomInt(0, description.length)],
        numberPages: numberPages[getRandomInt(0, numberPages.length)],
        genre: genre[getRandomInt(0, genre.length)],
        publishingHouse: publishingHouse[getRandomInt(0, publishingHouse.length)]
    });
}

const router = new Router();

router.get('/books', ctx => {
    books.forEach(element => {
        console.log("Get: " + element.id);
    });
    ctx.response.body = books;
    ctx.response.status = 200;
});

const broadcast = (data) =>
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(data));
        }
    });

router.post('/book', ctx => {
    const headers = ctx.request.body;
    console.log("Add: " + JSON.stringify(headers));
    const name = headers.name;
    const author = headers.author;
    const description = headers.description;
    const numberPages = headers.numberPages;
    const genre = headers.genre;
    const publishingHouse = headers.publishingHouse;

    if (typeof name !== 'undefined' &&
        typeof author !== 'undefined' &&
        typeof description !== 'undefined' &&
        typeof numberPages !== 'undefined' &&
        typeof genre !== 'undefined' && 
		typeof publishingHouse !== 'undefined') {

        let maxId = Math.max.apply(Math, books.map(function(obj) {
            return obj.id;
        })) + 1;
        let obj = {
            id: maxId,
            name,
            author,
            description,
            numberPages,
            genre,
            publishingHouse
        };
        console.log("Was added: " + JSON.stringify(obj));
        books.push(obj);
        broadcast(obj);
        ctx.response.body = obj;
        ctx.response.status = 200;
    } else {
        console.log("Missing or invalid fields!");
        ctx.response.body = { text: 'Missing or invalid fields!' };
        ctx.response.status = 404;
    }
});

router.get('/book/:id', ctx => {
    const headers = ctx.params;
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = exams.findIndex(order => order.id == id);
        if (index === -1) {
            console.log("Book not available!");
            ctx.response.body = { text: 'Book not available!' };
            ctx.response.status = 404;
        } else {
            let obj = exams[index];
            ctx.response.body = obj;
            ctx.response.status = 200;
        }
    } else {
        console.log("Missing or invalid: id!");
        ctx.response.body = { text: 'Missing or invalid: id!' };
        ctx.response.status = 404;
    }
});

router.del('/book/:id', ctx => { 
    const headers = ctx.params;
    console.log("Delete: " + JSON.stringify(headers));
    const id = headers.id;
    if (typeof id !== 'undefined') {
        const index = books.findIndex(obj => obj.id == id);
        if (index === -1) {
            console.log("No book with id: " + id);
            ctx.response.body = { text: 'Invalid book id.' };
            ctx.response.status = 404;
        } else {
            let obj = books[index];
            books.splice(index, 1);
            ctx.response.body = obj;
            ctx.response.status = 200;
        }
    } else {
        ctx.response.body = { text: 'Id missing or invalid' };
        ctx.response.status = 404;
    }
});

router.patch('/book', ctx => {
    const headers = ctx.request.body;
    console.log("Modify: " + JSON.stringify(headers));
    const id = parseInt(headers.id);
    const name = headers.name;
    const author = headers.author;
    const description = headers.description;
    const numberPages = headers.numberPages;
    const genre = headers.genre;
    const publishingHouse = headers.publishingHouse;

    if (typeof name !== 'undefined' &&
        typeof author !== 'undefined' &&
        typeof description !== 'undefined' &&
        typeof numberPages !== 'undefined' &&
        typeof genre !== 'undefined' && 
		typeof publishingHouse !== 'undefined') {

        let obj = {
            id: id,
            name,
            author,
            description,
            numberPages,
            genre,
            publishingHouse
        };
        console.log(id);
        const index = books.findIndex(obj => obj.id == id);
        if (index != -1) {
            books[index] = obj;
            broadcast(obj);
            ctx.response.body = obj;
            ctx.response.status = 200;
        } else {
            console.log("Missing or invalid fields!");
            ctx.response.body = { text: 'Missing or invalid fields!' };
            ctx.response.status = 404;
        }

    } else {
        console.log("Missing or invalid fields!");
        ctx.response.body = { text: 'Missing or invalid fields!' };
        ctx.response.status = 404;
    }
});

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2018);