
<p align="center">
  <img src="https://github.com/mzkyann/ALP-Canteen/blob/main/ALP-Canteen-struktur-frontend/cipeats/assets/images/logo.png" width="200" alt="Cipeats Logo" />
</p>

**Solusi Modern Pemesanan Makanan di Kantin UC Makassar**

![last-commit](https://img.shields.io/github/last-commit/mzkyann/ALP-Canteen?style=flat&logo=git&logoColor=white&color=0080ff)
![repo-top-language](https://img.shields.io/github/languages/top/mzkyann/ALP-Canteen?style=flat&color=0080ff)
![repo-language-count](https://img.shields.io/github/languages/count/mzkyann/ALP-Canteen?style=flat&color=0080ff)

**Built with the tools and technologies:**

![JSON](https://img.shields.io/badge/JSON-000000.svg?style=flat&logo=JSON&logoColor=white)
![Markdown](https://img.shields.io/badge/Markdown-000000.svg?style=flat&logo=Markdown&logoColor=white)
![npm](https://img.shields.io/badge/npm-CB3837.svg?style=flat&logo=npm&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-F05138.svg?style=flat&logo=Swift&logoColor=white)
![Composer](https://img.shields.io/badge/Composer-885630.svg?style=flat&logo=Composer&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E.svg?style=flat&logo=JavaScript&logoColor=black)
![Gradle](https://img.shields.io/badge/Gradle-02303A.svg?style=flat&logo=Gradle&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2.svg?style=flat&logo=Dart&logoColor=white)
![C++](https://img.shields.io/badge/C++-00599C.svg?style=flat&logo=C++&logoColor=white)
![XML](https://img.shields.io/badge/XML-005FAD.svg?style=flat&logo=XML&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B.svg?style=flat&logo=Flutter&logoColor=white)
![CMake](https://img.shields.io/badge/CMake-064F8C.svg?style=flat&logo=CMake&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4.svg?style=flat&logo=PHP&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-646CFF.svg?style=flat&logo=Vite&logoColor=white)
![Kotlin](https://img.shields.io/badge/Kotlin-7F52FF.svg?style=flat&logo=Kotlin&logoColor=white)
![Axios](https://img.shields.io/badge/Axios-5A29E4.svg?style=flat&logo=Axios&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E.svg?style=flat&logo=YAML&logoColor=white)

---

## 📌 Daftar Isi

- [📖 Tentang Proyek](#tentang-proyek)
- [🚀 Fitur Utama](#fitur-utama)
- [🛠 Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [🏛️ Arsitektur Sistem](#arsitektur-sistem)
- [⚙️ Instalasi & Setup](#instalasi--setup)
- [🔎 Lebih Lanjut](#lebih-lanjut)
- [👥 Tim Pengembang](#tim-pengembang)

---

## 📖 Tentang Proyek

**Cipeats** adalah aplikasi modern berbasis Flutter dan Laravel yang dikembangkan untuk mengatasi kepadatan dan antrean panjang di kantin Universitas Ciputra Makassar.

### 🎯 Latar Belakang

Kantin UC Makassar sering mengalami kepadatan saat jam makan karena ruang yang terbatas dan sistem pemesanan yang masih manual. Meskipun budaya antre cukup tertib, kerumunan di satu area membuat suasana menjadi sesak dan kurang nyaman. Pemesanan dari lokasi lain, seperti lantai atas, melalui aplikasi mobile dapat mengurangi antrean fisik dan memaksimalkan penggunaan ruang kantin.

---

## 🚀 Fitur Utama

- 🥗 **Pesan Makanan**  
  Mengurangi antrean fisik dengan memungkinkan pengguna memesan makanan dari lokasi mana pun di dalam kampus.

- 👀 **Lihat Order & Status Makanan**  
  Memberikan informasi real-time mengenai status pesanan, sehingga pengguna tahu kapan makanan siap diambil.

- 📋 **Menu Hari Ini**  
  Memudahkan pengguna memilih makanan yang tersedia setiap hari tanpa harus datang langsung ke kantin.

- 📜 **History Pesanan**  
  Menyimpan riwayat transaksi untuk mempermudah pemesanan ulang.

---

## 🛠 Teknologi yang Digunakan

- **Frontend**: Flutter, Dart, Riverpod, MVVM
- **Backend**: Laravel, PHP, MySQL, REST API, Laravel Sanctum
- **Tools**: Composer, npm, GitHub Actions

---

## 🏛️ Arsitektur Sistem

**Cipeats** menggunakan arsitektur client-server:

- **MVVM di Frontend**: View ↔ ViewModel ↔ Model  
- **MVC di Backend**: Model ↔ View ↔ Controller  

Komunikasi antara frontend dan backend dilakukan melalui **REST API**, dengan autentikasi token berbasis **Laravel Sanctum**.

---

## ⚙️ Instalasi & Setup

### Backend (Laravel)


```bash
git clone https://github.com/mzkyann/ALP-Canteen
cd ALP-Canteen/CipEats_Backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```

### Frontend (Flutter)

```bash
git clone https://github.com/mzkyann/ALP-Canteen
cd ALP-Canteen/ALP-Canteen-struktur-frontend/cipeats
flutter pub get
flutter run
````



## 🔎 Lebih Lanjut

* 📌 Miro Board untuk flow diagram dan use-case.
* 🎨 Canva Poster untuk keperluan presentasi visual.

---

## 👥 Tim Pengembang

© Cipeats Team - UC Makassar IMT '23

* **Muh Ryan Ardiansyah** - 0806022310019
* **Levin Dawson Wisan** - 0806022310020
* **Hainzel Kemal** - 0806022310010

---

⬆️ [Kembali ke atas](#alp-canteen)



