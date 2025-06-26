import os
from fastapi import FastAPI
from logger import logger
# 1
app = FastAPI()

def get_greeting():
    return os.getenv("GREETING_MSG", "Local")

@app.get("/greeting")
async def greeting():
    msg = get_greeting();
    logger.info(f"Greeting from {msg}")
    return {"greeting": msg}

@app.get("/healthz")
def health_check():
    return {"status": "ok"}
