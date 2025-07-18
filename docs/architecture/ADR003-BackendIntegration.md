# ADR 003 - Backend Integration Strategy

## Status
### Accepted

## Context 
### Aplikasi pemesanan makanan dibagi menjadi dua aplikasi terpisah untuk pembeli dan penjual, yang memerlukan integrasi backend untuk mengelola data yang sering berubah seperti daftar menu, status pesanan, dan informasi pengguna. Dengan arsitektur MVVM, UI pada masing-masing aplikasi perlu disinkronkan secara real-time dengan backend agar pembeli dan penjual selalu melihat data terbaru tanpa perlu me-refresh secara manual. Backend harus mampu menangani permintaan data yang sering diperbarui, serta mendukung komunikasi real-time melalui teknologi seperti WebSocket atau Server-Sent Events (SSE). Selain itu, backend harus dirancang untuk skalabilitas, memastikan aplikasi tetap responsif meskipun jumlah pengguna dan transaksi meningkat, serta memastikan pengelolaan otentikasi dan otorisasi pengguna yang tepat menggunakan JWT atau OAuth. Keterbatasan utama termasuk kebutuhan akan latensi rendah untuk pengalaman pengguna yang optimal dan kemampuan untuk mengelola data yang sering berubah tanpa menurunkan kinerja aplikasi.

## Decision
### Kami memutuskan untuk menggunakan RESTful API sebagai solusi backend integration karena pendekatannya yang sederhana, mudah dipelajari, dan telah menjadi standar industri yang luas. REST mendukung pemisahan yang jelas antara client dan server, memudahkan pengembangan tim kecil, serta mudah diintegrasikan dengan arsitektur MVVM yang kami gunakan. Selain itu, REST menawarkan skalabilitas yang baik, sehingga cocok untuk kebutuhan aplikasi kami yang terus berkembang.

## Alternatives
### Kami mempertimbangkan Firebase karena kemudahan integrasi dan kemampuannya dalam menyajikan data secara real-time. Firebase sangat cocok untuk aplikasi yang membutuhkan sinkronisasi langsung, serta memiliki layanan backend lengkap seperti autentikasi, notifikasi, dan database tanpa server. Firebase memiliki ketergantungan tinggi terhadap ekosistemnya sendiri, yang bisa menjadi hambatan jika kami ingin berpindah teknologi di masa depan. Biaya Firebase juga dapat meningkat seiring pertumbuhan pengguna dan lalu lintas data. 

## Consequences
###  Konsekuensinya adalah REST tidak secara native mendukung komunikasi real-time, sehingga dibutuhkan solusi tambahan seperti polling atau WebSocket untuk pembaruan data secara langsung. Selain itu, struktur endpoint yang semakin kompleks perlu dikelola dengan baik agar tidak menyulitkan proses pemeliharaan di masa depan.