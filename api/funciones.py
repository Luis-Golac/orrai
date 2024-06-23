import google.generativeai as genai

def mensaje_personalizado(nombre, evento, distancia, familiar, hora, ubicación):
    genai.configure(api_key='AIzaSyBMtxdKCrWyafkJsn5_q38ktZW5FSLBt0w')
    model = genai.GenerativeModel("models/gemini-1.5-flash")

    distancia_cercana = 300

    es_cercano = distancia <= distancia_cercana

    if familiar == "":
        if es_cercano:
            mensaje_inicio = f"!Emergencia! {nombre} {evento.upper()} detectado a {distancia} de usted, a las {hora} se recomienda:"
        else:
            mensaje_inicio = f"{nombre} {evento.upper()} detectado a {distancia} de usted, a las {hora} se recomienda:"

        prompt = f'Quiero que actues como una central de alertas y me recomiendes qué hacer en caso de una emergencia, además ten en cuenta que estoy en Perú así que contextualízalo. Todo en un maximo de 80 palabras,ten en cuenta que este mensaje será enviado por mensaje de texto de celular así que debe tener un formato de texto limpio y sencillo, y que el mensaje comience con: "{mensaje_inicio}". Por favor, NO uses ** para el formato del texto, ademas las recomendaciones deben estar enumeradas por guiones "-" '

        response = model.generate_content(prompt)
    else:
        if es_cercano:
            mensaje_inicio = f"!Emergencia! {nombre}, {evento.upper()} detectado a las {hora} en {ubicación} a {distancia} de la ubicacion actual de {familiar} (marcado como favorito),  se recomienda:"
        else:
            mensaje_inicio = f"{nombre}, se ha detectado un {evento.upper()} a {distancia} de {familiar} marcado como favorito, a las {hora} se recomienda:"

        prompt = f'Quiero que actues como una central de alertas y me recomiendes qué hacer o cómo apoyar en caso de que un familiar o alguien muy cercano esté cerca de una emergencia (como incendios, sismos, accidentes, etc.). Ten en cuenta que estoy en Perú, así que contextualízalo. Todo en un máximo de 80 palabras. Este mensaje será enviado por mensaje de texto de celular, así que debe tener un formato de texto limpio y sencillo, y que el mensaje comience con: "{mensaje_inicio}". Por favor, NO uses ** para el formato del texto, además las recomendaciones deben estar enumeradas por guiones "-" y deben incluir acciones para comunicarse con el familiar.'

        response = model.generate_content(prompt)

    return response.text
