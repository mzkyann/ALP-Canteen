# ADR 004 - Local Data Persistance

## Status
### Accepted

## Context 
### Kami ingin menyediakan dukungan offline dan caching untuk aplikasi pemesanan makanan yang dibagi menjadi aplikasi pembeli dan penjual. Aplikasi ini memuat data yang sering berubah, seperti daftar menu, status pesanan, dan informasi pengguna. Untuk menjaga performa, integritas data, dan dukungan terhadap pemrosesan data terstruktur, kami membutuhkan solusi penyimpanan lokal yang stabil, fleksibel, serta mudah diintegrasikan dengan arsitektur MVVM yang kami gunakan.

## Decision
### Kami memutuskan untuk menggunakan SQLite sebagai mekanisme penyimpanan data lokal karena merupakan basis data relasional yang sudah terbukti stabil, mendukung struktur data kompleks, dan memiliki ekosistem tooling yang luas. SQLite cocok untuk menyimpan data terstruktur seperti pesanan, menu, dan pengguna yang memiliki relasi satu sama lain. SQLite juga memungkinkan kami untuk melakukan query data secara efisien serta menyediakan fleksibilitas dalam mengelola skema dan migrasi basis data. Selain itu, tim kami sudah lebih familiar dengan SQL dan konsep relasional (RDBMS), sehingga proses pengembangan dan debugging dapat dilakukan dengan lebih efisien dan minim risiko kesalahan.

## Alternative
### Kami mempertimbangkan menggunakan Hive karena sangat cepat dan mudah diatur, serta cocok untuk caching data sederhana. Namun, Hive kurang mendukung relasi antar data dan tidak ideal untuk skema data yang kompleks. Sembast kami anggap terlalu terbatas dalam performa dan skalabilitas untuk skenario aplikasi kami yang padat data. ObjectBox kami anggap terlalu berat untuk tim kami karena memerlukan setup tambahan dan belum memiliki pengalaman dalam penggunaannya, meskipun fiturnya menarik seperti dukungan reactive dan efisiensi tinggi. Oleh karena itu, SQLite kami nilai sebagai opsi yang paling seimbang antara fleksibilitas, familiaritas, kontrol penuh terhadap data, dan kestabilan jangka panjang.

## Consequence
### Konsekuensinya adalah dibutuhkan penulisan skema dan query SQL secara manual, yang bisa menambah beban kerja dan kompleksitas pada tahap awal pengembangan. Tim juga perlu memahami cara migrasi data antar versi database dengan benar. Selain itu, SQLite tidak bersifat reactive secara bawaan, sehingga integrasi tambahan atau penggunaan pattern tertentu diperlukan untuk menyinkronkan perubahan data dengan UI.