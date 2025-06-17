# ADR 008 - Offline Support & Caching

## Status

### Accepted

## Context

### Aplikasi kami digunakan oleh mahasiswa di lingkungan kampus, di mana koneksi internet tidak selalu stabil. Namun, karena data seperti daftar makanan dan status pesanan sangat dinamis dan berubah setiap hari, penggunaan data lama sangat berisiko menyebabkan kesalahan informasi. Oleh karena itu, kami memprioritaskan agar data yang ditampilkan kepada pengguna selalu yang paling baru dan valid. Dalam kondisi tanpa koneksi internet, aplikasi akan membatasi fungsionalitas dan tidak menampilkan data agar menghindari menampilkan informasi yang sudah tidak relevan.

## Decision

### Kami memutuskan untuk menggunakan pendekatan **online-first**, yaitu aplikasi akan selalu mencoba mengambil data langsung dari server setiap kali dibuka atau diakses. Jika koneksi internet tersedia, data terbaru akan ditampilkan kepada pengguna. Namun, jika tidak ada koneksi internet, maka aplikasi akan menampilkan informasi bahwa data tidak tersedia dan pengguna diminta untuk menghubungkan perangkat ke internet. Pendekatan ini dipilih karena menjamin bahwa semua data yang ditampilkan bersifat real-time dan tidak usang, yang sangat penting dalam konteks pemesanan makanan yang cepat berubah.

## Consequence

### Dengan pendekatan online-first, aplikasi selalu menampilkan data terbaru yang diambil langsung dari server, sehingga menghindari risiko kesalahan informasi. Namun, pengguna tidak dapat mengakses fitur utama saat tidak terhubung ke internet, yang berarti aplikasi akan memberikan notifikasi atau tampilan fallback untuk kondisi offline. Pendekatan ini mengurangi kompleksitas pada sisi klien karena tidak memerlukan sinkronisasi data lokal, namun mengandalkan ketersediaan dan kestabilan koneksi internet untuk pengalaman pengguna yang optimal.