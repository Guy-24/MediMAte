# main.py

from fastapi import FastAPI, File, UploadFile, HTTPException
import uvicorn
import openai
import json
import base64
import os
from typing import Optional

app = FastAPI()

# Set your OpenAI API key
client = openai.OpenAI(
  api_key = 'OPENAI_API_KEY'
)

# Function to encode the image
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

# Function to process the image and get the JSON result
def process_image(image_path):
    base64_image = encode_image(image_path)

    prompt = """
    กรุณาอธิบายข้อมูลที่ปรากฏในรูปภาพ โดยระบุข้อความทั้งหมด รวมถึงส่วนที่มีการขีดฆ่า วงกลม หรือการทำเครื่องหมายอื่น ๆ พร้อมระบุตำแหน่งที่เกี่ยวข้อง

    ตัวอย่าง:
    ข้อความ:
      XXXX
      XXXX
      XXXX
      XXXX
    การทำเครื่องหมาย:
      ขีดฆ่า:
        XXXX
      วงกลม:
        XXXX
    """

    response1 = client.chat.completions.create(
  model="gpt-4o-mini",
  messages=[
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": prompt,
        },
        {
          "type": "image_url",
          "image_url": {
            "url": f"data:image/jpeg;base64,{base64_image}"
          },
        },
      ]
    }
  ],
  temperature=0.8,
  # max_tokens=2000,
)


    res = response1.choices[0].message.content

    prompt2 = f"""
    {res}
    กรุณาดึงข้อมูลดังต่อไปนี้:

    - ชื่อยา
    - จำนวนยาที่มี
    - ปริมาณยาที่รับประทานต่อครั้ง
    - ช่วงเวลาที่รับประทาน
    - เวลารับประทาน (เช่น เช้า, กลางวัน, เย็น, ก่อนนอน)
    - เงื่อนไขในการรับประทานยา (เช่น ก่อนอาหาร, หลังอาหาร, เมื่อมีอาการ)
    - ข้อควรระวัง

    **หมายเหตุ:**

    - หากมีการขีดฆ่า ห้ามนำข้อความนั้นมาใช้
    - ให้ตอบเฉพาะข้อมูลที่ถูกวงกลมครอบคลุมเท่านั้น

    โปรดนำเสนอข้อมูลในรูปแบบ JSON ดังนี้:

    ```json
      "pill_name": "ชื่อยา",
      "amount": XXX,           // จำนวนยา (ตัวเลข)
      "dose": XXX,             // จำนวนยารับประทานครั้งละ  (ตัวเลข)
      "datae": "XXX",           // เวลารับประทาน (เช่น เช้า, กลางวัน, เย็น, ก่อนนอน)
      "time_condition": "XXX", // เงื่อนไขเวลารับประทาน (เช่น ก่อนอาหาร, หลังอาหาร, เมื่อมีอาการ)
      "warning": "XXX"         // ข้อควรระวัง
    ```
    """

    response2 = client.chat.completions.create(
  model="gpt-4o",
  messages=[
    {
      "role": "user",
      "content":[
        {
          "type": "text",
          "text": prompt2,
        },
      ]
    }
  ],
  temperature=0.8,
  # max_tokens=2000,
)


    res2 = response2.choices[0].message.content

    # Parse the JSON response
    try:
        data_dict = json.loads(res2.replace('```','').replace('json',''))
    except json.JSONDecodeError as e:
        raise ValueError("Failed to parse JSON response from OpenAI API") from e

    # Additional processing
    def text_to_number(text: Optional[str]):
        mapping = {
            "เช้า": 8,
            "กลางวัน": 12,
            "เย็น": 18,
            "ก่อนนอน": 22
        }
        return mapping.get(text, -1)

    data_dict['time'] = text_to_number(data_dict.get('datae', ''))

    return data_dict

@app.post("/process-image/")
async def process_image_endpoint(file: UploadFile = File(...)):
    # Save the uploaded file
    try:
        contents = await file.read()
        file_location = f"uploaded_images/{file.filename}"
        os.makedirs(os.path.dirname(file_location), exist_ok=True)
        with open(file_location, "wb") as f:
            f.write(contents)
    except Exception:
        raise HTTPException(status_code=500, detail="Could not save the uploaded file") 

    # Process the image
    try:
        result = process_image(file_location)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    return result

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
