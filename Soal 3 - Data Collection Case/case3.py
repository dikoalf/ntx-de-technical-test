import httpx
from bs4 import BeautifulSoup
import asyncio
import os
import json
import polars as pl
from tqdm import tqdm

async def fetchPage(page, skippedPages):
    url = f"https://www.fortiguard.com/encyclopedia?type=&page={page}&date="
    try:
        async with httpx.AsyncClient(timeout=10) as client:
            response = await client.get(url)
            response.raise_for_status()
            soup = BeautifulSoup(response.text, 'html.parser')

            # mengambil semua div yang memiliki onclick
            threats = soup.select('div.row[onclick]')
            data = []

            # dikarenakan risk level menjadi hidden element, sehingga penyimpanan disesuaikan dengan menyusun data bedasarkan threat typenya
            for threat in threats:
                # mengambil nama ancaman dari <small> tag
                threatTypeTag = threat.select_one('small')
                if threatTypeTag:
                    threatType = threatTypeTag.get_text(strip=True).replace(" ", "_").lower()
                else:
                    threatType = "unknown"

                # mengambil judul dari <b> tag
                titleTag = threat.select_one('b')
                if titleTag:
                    title = titleTag.get_text(strip=True)
                else:
                    title = "No title available"

                # mengambil link dari atribut onclick
                onclickValue = threat['onclick']
                link = onclickValue.split("'")[1]
                fullLink = f"https://www.fortiguard.com{link}"

                data.append({
                    "threatType": threatType,
                    "title": title,
                    "link": fullLink
                })

            print(f"Data berhasil diambil dari halaman {page}")

            return data

    except (httpx.RequestError, httpx.HTTPStatusError) as e:
        print(f"Error fetching {url}: {e}")
        skippedPages.append(page)
        return []

async def main():
    skippedPages = []
    allData = {}

    # menggunakan tqdm untuk menampilkan progress bar
    for page in tqdm(range(1, 501), desc="Fetching pages"):
        data = await fetchPage(page, skippedPages)
        for entry in data:
            threatType = entry["threatType"]
            if threatType not in allData:
                allData[threatType] = []
            allData[threatType].append(entry)

    # membuat direktori datasets jika belum ada
    os.makedirs('datasets', exist_ok=True)

    # menyimpan data ke file CSV berdasarkan threat type menggunakan polars
    for threatType, entries in allData.items():
        df = pl.DataFrame(entries)
        fileName = f'datasets/forti_threat_type_{threatType}.csv'
        df.write_csv(fileName)

    # menyimpan halaman yang terlewat ke file skipped.json
    if skippedPages:
        with open('datasets/skipped.json', 'w', encoding='utf-8') as f:
            json.dump({"skippedPages": skippedPages}, f, ensure_ascii=False, indent=4)

    print("Scraping selesai")


if __name__ == "__main__":
    asyncio.run(main())
