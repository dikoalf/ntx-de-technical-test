# Gunakan `python:3.11.4` sebagai base image
FROM python:3.11.4

# mengatur direktori kerja di dalam container
WORKDIR /app

# menyalin file requirements.txt ke dalam container di /app
COPY requirements.txt /app/

# menginstal paket yang dibutuhkan sesuai dengan requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# menyalin seluruh konten direktori saat ini ke dalam container di /app
COPY . /app

# membuka port 6000 agar bisa diakses dari luar container
EXPOSE 6000

# menjalankan aplikasi FastAPI dengan Uvicorn saat container diluncurkan
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "6000"]
