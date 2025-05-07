# ADR 010 - Testing Strategy & CI/CD Pipeline

## Status
### Accepted

## Context 
### Untuk menjaga stabilitas dan kualitas aplikasi, penting untuk memiliki strategi pengujian yang memastikan setiap fitur berjalan sesuai harapan. Pengujian ini juga membantu menghindari regresi saat aplikasi berkembang. Selain itu, banyak tim menggunakan CI/CD pipeline untuk mengotomasi proses build dan testing, namun kami mempertimbangkan pendekatan manual karena keterbatasan tim dan infrastruktur.

## Decision
### Kami memutuskan untuk mengadopsi strategi pengujian manual dan semi-otomatis, dengan fokus pada unit test untuk logic penting (misalnya perhitungan harga dan validasi input), serta widget test untuk komponen UI yang kompleks. Untuk pengujian integrasi dan alur penuh, kami akan melakukan testing manual secara berkala. Kami tidak akan menggunakan CI/CD pipeline karena skala tim yang kecil dan frekuensi rilis yang tidak tinggi, sehingga proses build dan deployment akan dilakukan secara manual oleh developer.

## Alternative
### Kami mempertimbangkan penggunaan GitHub Actions atau GitLab CI untuk membangun pipeline otomatis. Namun, pendekatan ini membutuhkan waktu setup, pemeliharaan, serta penyesuaian dengan infrastruktur rilis, yang saat ini belum menjadi prioritas. Dalam jangka panjang, CI/CD dapat dipertimbangkan kembali jika kebutuhan pengembangan meningkat.

## Consequence
### Dengan tidak menggunakan CI/CD pipeline, proses build dan pengujian akan lebih bergantung pada kedisiplinan tim dan dokumentasi yang jelas. Proses rilis juga akan memakan waktu lebih lama secara manual, dan berisiko terjadi human error. Namun, pendekatan ini mengurangi kompleksitas dan beban kerja dalam tahap awal pengembangan.