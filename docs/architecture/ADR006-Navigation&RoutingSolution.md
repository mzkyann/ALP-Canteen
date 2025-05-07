# ADR 006 - Navigation & Routing Solution

## Status
### Accepted

## Context 
### Aplikasi kami memiliki beberapa alur navigasi, seperti login, dashboard pembeli, dashboard penjual, halaman detail makanan, dan status pesanan. Kami memerlukan solusi navigasi yang fleksibel untuk menangani role-based flow, nested navigation, dan deep link, serta bisa diintegrasikan dengan state management Riverpod dan arsitektur MVVM yang telah kami tetapkan.

## Decision
### Kami memutuskan untuk menggunakan Navigator bawaan Flutter dalam mengelola navigasi aplikasi.  Navigator 2.0 memberikan kontrol penuh, fleksibilitas tinggi, dan tanpa ketergantungan pada package eksternal, sehingga dapat disesuaikan sepenuhnya dengan struktur MVVM dan logika aplikasi yang dikelola melalui Riverpod.

## Alternative
### Kami mempertimbangkan menggunakan go_router karena menawarkan abstraksi deklaratif di atas Navigator 2.0, serta fitur-fitur seperti nested route dan redirect yang mudah digunakan. Namun, untuk kasus kami, go_router terlalu abstrak dan tim kami belum berpengalaman dalam menggunakannya.

## Consequence
### Konsekuensinya adalah kami harus menangani lebih banyak kode boilerplate, terutama untuk fitur seperti route guard, nested navigation, dan deep linking.