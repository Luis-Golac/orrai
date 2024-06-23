from fastapi import FastAPI
from pydantic import BaseModel
from funciones import mensaje_personalizado

class MensajeInput(BaseModel):
    nombre: str
    evento: str
    distancia: int
    familiar: str
    hora: str
    ubicacion: str


app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}


@app.post("/crear_mensaje/")
def create_mensaje(input: MensajeInput):
    mensaje = mensaje_personalizado(
        input.nombre,
        input.evento,
        input.distancia,
        input.familiar,
        input.hora,
        input.ubicacion
    )
    print(mensaje)
    return {"mensaje": mensaje}
