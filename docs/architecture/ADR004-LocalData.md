# ADR 004 - Local Data Persistence

## Status

### Accepted

## Context

### Kami ingin menyediakan dukungan penyimpanan data lokal pada aplikasi pemesanan makanan yang terdiri dari aplikasi pembeli dan penjual. Data yang disimpan secara lokal mencakup data yang tidak besar dan tidak terlalu kompleks, seperti token autentikasi, status login, preferensi pengguna, dan informasi sementara lainnya. Untuk mendukung kebutuhan tersebut, kami memerlukan solusi yang ringan, aman, dan mudah diintegrasikan dengan arsitektur Flutter yang kami gunakan.

## Decision

### Kami memutuskan untuk menggunakan dua solusi penyimpanan lokal di Flutter: **Shared Preferences** dan **Flutter Secure Storage**.

* **Shared Preferences** akan digunakan untuk menyimpan data non-sensitif seperti status login, preferensi tampilan, atau pengaturan aplikasi yang tidak memerlukan enkripsi. Shared Preferences mudah digunakan dan mendukung penyimpanan key-value secara ringan dan cepat.
* **Flutter Secure Storage** akan digunakan untuk menyimpan data sensitif seperti token autentikasi dan informasi yang membutuhkan keamanan tingkat tinggi, karena data dienkripsi dan disimpan secara aman di perangkat menggunakan keystore (Android) atau keychain (iOS).

## Consequence

### Penggunaan dua metode penyimpanan lokal ini membutuhkan pemilihan strategi yang tepat agar data disimpan di tempat yang sesuai berdasarkan tingkat sensitivitasnya. Shared Preferences tidak cocok untuk menyimpan informasi penting karena tidak terenkripsi secara default. Sementara itu, Flutter Secure Storage memiliki keterbatasan performa untuk penyimpanan data dalam jumlah besar atau akses yang sangat sering, sehingga perlu dioptimalkan penggunaannya. Tim juga perlu menjaga konsistensi dalam penggunaan key dan manajemen data antar dua metode ini agar tidak membingungkan saat pengembangan dan pemeliharaan aplikasi.
