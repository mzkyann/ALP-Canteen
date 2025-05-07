# ADR 005 - Dependancy Injection Framework

## Status
### Accepted

## Context 
### Aplikasi kami membutuhkan pengelolaan state yang terstruktur dan efisien, terutama untuk menangani data yang terus berubah dan interaksi antar pengguna seperti daftar makanan, status pesanan, dan informasi pengguna. Karena data bersifat dinamis dan sering asinkron, dibutuhkan solusi yang dapat memisahkan UI dari logic dengan jelas, serta tetap mudah di-maintain oleh tim kecil.

## Decision
### Kami memutuskan untuk menggunakan Riverpod sebagai solusi state management utama tanpa menggunakan pendekatan injection manual. Kami memilih pendekatan ini karena lebih sederhana, tidak memerlukan setup injection kompleks, dan tetap menjaga arsitektur aplikasi tetap bersih dan terstruktur.

## Alternative
### Kami mempertimbangkan menggunakan Provider, karena lebih sederhana dan sudah umum digunakan. Namun, Provider kurang fleksibel untuk skenario kompleks dan penanganan asinkron yang intensif. Kami juga mempertimbangkan menggunakan BLoC, yang unggul dalam kontrol alur event dan state secara eksplisit, namun membutuhkan boilerplate yang lebih banyak dan kurva belajar lebih tinggi untuk tim kami. Riverpod dipilih karena berada di tengah-tengah antara kemudahan dan skalabilitas.

## Consequence
### Dengan menggunakan Riverpod tanpa injection, kode menjadi lebih langsung dan mudah dibaca. Kami dapat mengelola state global atau scoped secara efisien tanpa harus menyusun layer dependency secara eksplisit. Namun, pendekatan ini tetap membutuhkan pemahaman tentang konsep provider dan scope, serta struktur file yang konsisten agar maintainability tetap terjaga saat aplikasi berkembang.