# ADR 001 App Architectural Pattern

## Status
### Accepted

## Context 
### Kami ingin membuat aplikasi pemesanan makanan yang terbagi atas aplikasi untuk pembeli dan penjual. Aplikasi menggunakan Flutter, dan dikerjakan dalam skala kecil ke menengah. Diperlukan struktur yang rapih dan mudah dimengerti, dan juga UI yang reaktif, karena banyak data yang selalu terupdate.

## Decision
### Dari pembahasan yang kami lakukan, kami menyimpulkan bahwa architecture yang paling sesuai dengan aplikasi kami adalah MVVM. Kami memilih MVVM karena aplikasi kami bersifat reaktif, dan digunakan dalam skala kecil atau menengah.

## Alternative
### Architecture alternatif lain yang kami pertimbangkan adalah MVC. Kami pertimbangkan MVC karena sesuai dengan skala aplikasi kami dan mudah diterapkan, tetapi dengan architecture MVC, akan semakin susah dengan banyaknya data dan fitur yang akan ditangani karena bersifat non-reaktif. Architecture alternatif lain yang kami pertimbangkan adalah Clean Architecture. Kami pertimbangkan menggunakan Clean Architecture karena gampang dilakukan testing dan fleksibel, tetapi kekurangannya adalah memiliki stuktur yang kompleks dan tidak sesuai dengan skala aplikasi yang kami gunakan.

## Consequences
### Kelebihan yang kami dapatkan adalah MVVM sudah sesuai untuk aplikasi kami karena MVVM bisa reaktif tetapi kekurangan menggunakan MVVM adalah butuh terbiasa saat awal digunakan, karena perlu mengerti hubungan antara view model dan view. 