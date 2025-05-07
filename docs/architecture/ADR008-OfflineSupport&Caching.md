# ADR 008 - Offline Support & Caching

## Status
### Accepted

## Context 
### Aplikasi kami digunakan oleh mahasiswa dengan kondisi jaringan yang kadang tidak stabil. Namun, karena data yang ditampilkan—seperti daftar makanan dari vendor yang bersifat sangat dinamis dan berubah setiap hari, maka data lama berisiko membuat pengguna salah informasi. Oleh karena itu, aplikasi harus memastikan bahwa data yang ditampilkan selalu terkini. Jika tidak ada koneksi internet, aplikasi tidak akan dapat digunakan secara penuh, demi menghindari penggunaan data kadaluarsa.

## Decision
### Kami memutuskan untuk menggunakan pendekatan local-first dengan menyimpan data penting secara lokal menggunakan SQLite. Aplikasi akan menampilkan data langsung dari database lokal terlebih dahulu untuk menjaga kecepatan dan responsivitas, kemudian menyinkronkan data dengan server ketika koneksi tersedia. Pendekatan ini dipilih karena memberikan kontrol penuh atas struktur data lokal, cocok untuk data relasional, dan efisien digunakan dalam kondisi internet yang tidak selalu stabil, seperti di kantin atau kampus UC. SQLite juga sudah umum digunakan dan didukung dengan baik di Flutter.

## Alternative
### Kami mempertimbangkan penggunaan HTTP, namun pendekatan ini tidak menjamin data tersedia saat offline tanpa tambahan logika di sisi klien, serta tidak cukup fleksibel untuk kebutuhan kompleks seperti relasi antar data. Kami juga mempertimbangkan membangun layer caching khusus di atas API, namun pendekatan ini memerlukan arsitektur dan effort tambahan yang tidak sebanding dengan kebutuhan dan skala aplikasi saat ini.

## Consequence
### Dengan menggunakan local-first approach, aplikasi menjadi lebih responsif dan tetap bisa digunakan saat offline karena data dibaca langsung dari database lokal yaitu SQLite. Namun, pendekatan ini menambah kompleksitas, terutama dalam hal sinkronisasi data antara lokal dan server, penanganan konflik, serta memastikan data tetap valid dan konsisten. Meski membutuhkan logika tambahan, pendekatan ini sebanding dengan peningkatan pengalaman pengguna, terutama dalam kondisi internet yang tidak stabil.