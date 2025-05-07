# ADR 002 App State Management Approach

## Status
### Accepted

## Context 
### Kami ingin membuat aplikasi pemesanan makanan yang terbagi atas aplikasi untuk pembeli dan penjual, dengan data yang sering berubah seperti daftar menu, status pesanan, dan informasi pengguna. Untuk menjaga UI tetap sinkron dengan data, dan mendukung arsitektur MVVM yang telah dipilih, kami memerlukan pendekatan state management yang mendukung UI reaktif, cocok untuk tim kecil, scalable untuk pengembangan jangka panjang, dan mudah diuji pada level ViewModel.

## Decision
### Kami memutuskan untuk menggunakan Riverpod sebagai solusi state management karena mendukung arsitektur MVVM, bersifat reaktif, modular, dan mudah diuji. Riverpod juga scalable dan cocok untuk kebutuhan aplikasi kami yang melibatkan data dinamis dan pengembangan jangka panjang.

## Alternative
### Kami mempertimbangkan menggunakan Provider karena mudah digunakan. Tetapi, Provider kurang fleksibel untuk memisahkan logika dari UI, dan susah untuk pengujian ViewModel. Oleh karena itu, Provider kami anggap kurang sesuai untuk kebutuhan aplikasi kami yang bersifat dinamis dan terus berkembang. Kami tidak menggunakan BLoC karena memiliki struktur yang kompleks dan mendukung pemisahan yang jelas antara UI dan logika bisnis. BLoC cocok untuk aplikasi besar dengan tim yang lebih besar. Namun, kekurangannya adalah stukturnya yang kompleks dan rumit. Untuk aplikasi skala menengah dengan kebutuhan reaktif dan efisiensi pengembangan, BLoC dirasa terlalu berat, sehingga kami memilih Riverpod.

## Consequences
### Konsekuensinya adalah dibutuhkan waktu adaptasi bagi anggota tim yang belum familiar dalam menggunakan Riverpod, serta butuh dipelajari cara penulisan kode agar struktur tetap konsisten dan tidak membebani ViewModel. Riverpod membutuhkan waktu yang lebih lama dalam pengembangan aplikasinya karena lebih kompleks