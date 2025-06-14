import os
from fastapi import FastAPI

app = FastAPI()

def get_greeting():
    return os.getenv("GREETING_MSG", "Hello, World!")

@app.get("/greeting")
async def greeting():
    return {"greeting": get_greeting()}

@app.get("/healthz")
def health_check():
    return {"status": "ok"}
