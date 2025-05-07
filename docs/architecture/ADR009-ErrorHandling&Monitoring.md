# ADR 009 - Error Handling & Monitoring

## Status
### Accepted

## Context 
### Untuk menjaga kualitas aplikasi dan merespons masalah secara cepat, kami membutuhkan sistem pelaporan error dan monitoring performa aplikasi di lingkungan produksi. Sistem ini harus mampu menangkap crash, log penting, serta memberikan informasi kontekstual (seperti versi aplikasi dan perangkat) agar tim dapat segera menangani masalah yang terjadi pada pengguna.

## Decision
### Kami memutuskan untuk menggunakan Sentry sebagai solusi utama untuk error tracking dan monitoring. Sentry mendukung integrasi langsung dengan Flutter, mampu menangkap unhandled exceptions, serta menyediakan dashboard yang lengkap untuk memantau error secara real time. Selain itu, Sentry memiliki versi gratis dengan fitur yang cukup untuk skala aplikasi kami, sehingga cocok untuk tim kecil dan kebutuhan awal produksi.

## Alternative
### Kami mempertimbangkan menggunakan Firebase Crashlytics, namun Sentry memberikan kontrol dan visibilitas yang lebih tinggi terhadap stack trace dan log, serta mendukung pelacakan error kustom yang lebih fleksibel. Solusi custom logging juga dipertimbangkan, tapi membutuhkan waktu implementasi dan lebih kompleks, yang tidak sepadan dengan kebutuhan saat ini.

## Consequence
### Dengan menggunakan Sentry, kami bisa memantau error dan crash secara proaktif dan meningkatkan stabilitas aplikasi. Namun, integrasi awal membutuhkan setup project di Sentry dan konfigurasi minimal di Flutter. Tim juga perlu menerapkan praktik logging yang baik agar data yang dikirim relevan dan tidak membanjiri sistem.