#!/usr/bin/env python

# WS client example

import asyncio
import websockets
import logging
   
   
   

logger = logging.getLogger('websockets')
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler())


async def hello():
    # uri = "ws://0.0.0.0:8765"
    uri = "ws://localhost:8080/httpbin"
    apikey = "ZC2WuiJp61NmC2MnU81afEHASGtvw9l0"
    # apikey = "GthmdgrBoXgpzoJcZ8ye74YuXsmEGHfS"
 
    while True:
        try:
            async with websockets.connect(uri,extra_headers=websockets.http.Headers({'x-api-key': apikey})) as websocket:
                name = input("What's your name? ")
                
                await websocket.send(name)
                print(f"> {name}")

                greeting = await websocket.recv()
                print(f"< {greeting}")
        except Exception as e:
            print(e)

asyncio.get_event_loop().run_until_complete(hello())
