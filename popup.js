// GANTIKAN DENGAN WEB APP URL ANDA DARIPADA GOOGLE APPS SCRIPT
const GAS_API_URL = "https://script.google.com/macros/s/AKfycbzjL-uWv1mee1PfSRHl2wIp4mfdw_7Vz2_r6k4mnROTHc9iFKKdYXY4qKk6fEZV2Kd87A/exec";

let dbData = {};

document.addEventListener('DOMContentLoaded', function() {
  lucide.createIcons();
  
  const tahunSelect = document.getElementById('tahun');
  const kelasSelect = document.getElementById('kelas');
  const muridSelect = document.getElementById('murid');
  const btnLogin = document.getElementById('btnLogin');
  const themeToggle = document.getElementById('themeToggle');

  // Muat Data dari Google Apps Script
  if (!GAS_API_URL || GAS_API_URL.includes("TAMPAL_WEB_APP_URL")) {
    tahunSelect.innerHTML = '<option value="">⚠️ Sila masukkan URL Web App dalam kod!</option>';
    return;
  }

  fetch(GAS_API_URL)
    .then(res => res.json())
    .then(data => {
      dbData = data;
      tahunSelect.innerHTML = '<option value="">-- Sila Pilih Tahun --</option>';
      Object.keys(dbData).forEach(tahun => {
        let opt = document.createElement('option');
        opt.value = tahun;
        opt.textContent = tahun;
        tahunSelect.appendChild(opt);
      });
    })
    .catch(err => {
      tahunSelect.innerHTML = '<option value="">❌ Gagal memuatkan data.</option>';
    });

  // Event Listener dropdown Tahun
  tahunSelect.addEventListener('change', function() {
    let tahun = this.value;
    kelasSelect.innerHTML = '<option value="">-- Sila Pilih Kelas --</option>';
    muridSelect.innerHTML = '<option value="">-- Sila Pilih Kelas Terlebih Dahulu --</option>';
    muridSelect.disabled = true;
    btnLogin.disabled = true;

    if (tahun && dbData[tahun]) {
      kelasSelect.disabled = false;
      for (let kelas in dbData[tahun]) {
        let opt = document.createElement('option');
        opt.value = kelas;
        opt.textContent = kelas;
        kelasSelect.appendChild(opt);
      }
    } else {
      kelasSelect.disabled = true;
    }
  });

  // Event Listener dropdown Kelas
  kelasSelect.addEventListener('change', function() {
    let tahun = tahunSelect.value;
    let kelas = this.value;
    muridSelect.innerHTML = '<option value="">-- Sila Pilih Nama Murid --</option>';
    btnLogin.disabled = true;

    if (tahun && kelas && dbData[tahun][kelas]) {
      muridSelect.disabled = false;
      dbData[tahun][kelas].forEach(student => {
        let opt = document.createElement('option');
        opt.value = student.email;
        opt.textContent = student.nama;
        muridSelect.appendChild(opt);
      });
    } else {
      muridSelect.disabled = true;
    }
  });

  // Event Listener dropdown Murid
  muridSelect.addEventListener('change', function() {
    btnLogin.disabled = !this.value;
  });

  // Event Listener Butang Log Masuk
  btnLogin.addEventListener('click', function() {
    let email = muridSelect.value;
    if (email) {
      let redirectUrl = "https://accounts.google.com/AccountChooser?Email=" + encodeURIComponent(email);
      chrome.tabs.create({ url: redirectUrl });
    }
  });
});
