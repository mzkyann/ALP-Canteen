# ADR 007 - Theming & UI Styling

## Status
### Accepted

## Context 
### Untuk memastikan tampilan aplikasi yang konsisten dan mudah dipelihara, kami memerlukan pendekatan theming dan styling yang efisien. Aplikasi kami akan digunakan oleh mahasiswa dan berjalan di Android dan iOS, sehingga tampilan harus intuitif, familiar, dan tidak memerlukan effort besar dari sisi desain dan implementasi. Tim kami beranggotakan tiga orang, sehingga efisiensi waktu dan penggunaan komponen siap pakai menjadi pertimbangan utama.

## Decision
### Kami memutuskan untuk menggunakan Flutter Material theming sebagai dasar gaya UI aplikasi, dan menambahkan custom styling untuk elemen-elemen tertentu agar sesuai dengan identitas visual aplikasi. Pendekatan hybrid ini memungkinkan kami untuk mempercepat pengembangan dengan komponen Material yang sudah stabil, sambil tetap memberikan tampilan yang lebih personal dan berbeda dari aplikasi standar.

## Alternative
### Kami mempertimbangkan untuk hanya menggunakan Material bawaan, namun tampilannya terlalu umum dan kurang mencerminkan branding aplikasi kami. Kami juga mempertimbangkan menggunakan Cupertino, namun karena aplikasi ditujukan untuk Android, Cupertino tidak kompatibel penuh dan akan menambah beban kerja desain dan pengujian di dua platform yang berbeda.

## Consequence
### Dengan menggunakan pendekatan hybrid (Material + custom), kami dapat menjaga konsistensi tampilan dan menghemat waktu pengembangan dengan tetap fleksibel menyesuaikan elemen visual. Namun, tim perlu menyepakati dan mendokumentasikan gaya UI agar desain tetap seragam saat aplikasi berkembang.