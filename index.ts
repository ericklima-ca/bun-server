import Bao from "baojs";
import Context from "baojs/dist/context";
const app: Bao = new Bao();

interface Mock {
    id: number,
    nome: string,
    pontos: number;
}

interface MockPayload {
    nome: string,
    pontos: number;
}

app.get("/", (ctx: Context) => {
    return ctx.sendText("OK");
});

app.get("/ping", (ctx: Context) => {
    return ctx.sendText("pong");
});

const lista: Mock[] = [
    {
        id: 1,
        nome: "Paulo",
        pontos: 21,
    },
    {
        id: 2,
        nome: "Daniel",
        pontos: 52,
    },
    {
        id: 3,
        nome: "Beatriz",
        pontos: 97,
    },
];

app.get("/points", (ctx: Context) => {
    return ctx.sendJson(lista);
});

app.post("/points", async (ctx: Context) => {
    const item: MockPayload = await ctx.req.json();
    lista.push({
        id: lista.length + 1,
        ...item
    });
    return ctx.sendText("Pontação criada");
});

app.listen({ port: 3000 });