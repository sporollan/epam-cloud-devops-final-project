from fastapi import FastAPI

app = FastAPI()

@app.get("/greeting")
async def greeting():
    return {"greeting": "Hello, World!"}