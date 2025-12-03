--
-- Skema Database Manajemen Proyek
-- Diurutkan berdasarkan dependensi Kunci Asing (Foreign Key)
-- Menggunakan sintaks standar SQL (kompatibel dengan MySQL)
--


-- Nonaktifkan pemeriksaan kunci asing sementara untuk mencegah masalah urutan pembuatan tabel
SET FOREIGN_KEY_CHECKS = 0;


-- ------------------------------
-- 1. Klien (clients) - INDEPENDEN
-- ------------------------------
CREATE TABLE klien (
    id_klien INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Klien',
    nama_klien VARCHAR(255) NOT NULL,
    perusahaan VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telepon VARCHAR(50) NULL,
    alamat TEXT NULL
);


-- ------------------------------
-- 2. Karyawan (employees) - INDEPENDEN
-- ------------------------------
CREATE TABLE karyawan (
    id_karyawan INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Karyawan',
    nama_karyawan VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telepon VARCHAR(50) NULL,
    posisi VARCHAR(100) NULL,
    tanggal_bergabung DATE NOT NULL
);


-- ------------------------------
-- 3. Peran (roles) - INDEPENDEN
-- ------------------------------
CREATE TABLE peran (
    id_peran INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Peran',
    nama_peran VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT NULL);


-- ------------------------------
-- 4. Kontrak (contracts) - Membutuhkan Klien (clients)
-- ------------------------------
CREATE TABLE kontrak (
    id_kontrak INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Kontrak',
    nomor_kontrak VARCHAR(100) NOT NULL UNIQUE,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    nilai_kontrak DECIMAL(18, 2) NULL,
    id_klien INT(11) NOT NULL,
    FOREIGN KEY (id_klien) REFERENCES clients(id_klien));


-- ------------------------------
-- 5. Proyek (projects) - Membutuhkan Klien dan Kontrak
-- ------------------------------
CREATE TABLE proyek (
    id_proyek INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Proyek',
    nama_proyek VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NULL,
    status ENUM('perencanaan', 'berjalan', 'selesai', 'ditunda') NOT NULL,
    id_klien INT(11) NOT NULL,
    id_kontrak INT(11) NULL UNIQUE, -- Kontrak bersifat unik jika ada
    FOREIGN KEY (id_klien) REFERENCES clients(id_klien),
    FOREIGN KEY (id_kontrak) REFERENCES contracts(id_kontrak));


-- ------------------------------
-- 6. Tim Proyek (project_teams) - Membutuhkan Proyek
-- ------------------------------
CREATE TABLE tim_proyek (
    id_tim INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Tim',
    nama_tim VARCHAR(255) NOT NULL,
    id_proyek INT(11) NOT NULL UNIQUE, -- Asumsi satu tim utama per proyek
    FOREIGN KEY (id_proyek) REFERENCES projects(id_proyek));


-- ------------------------------
-- 7. Anggota Tim (team_members) - Membutuhkan Tim, Karyawan, dan Peran
-- ------------------------------
CREATE TABLE anggota_tim (
    id_tim INT(11) NOT NULL,
    id_karyawan INT(11) NOT NULL,
    id_peran INT(11) NOT NULL,
    PRIMARY KEY (id_tim, id_karyawan), -- Kunci Komposit
    FOREIGN KEY (id_tim) REFERENCES project_teams(id_tim),
    FOREIGN KEY (id_karyawan) REFERENCES employees(id_karyawan),
    FOREIGN KEY (id_peran) REFERENCES roles(id_peran));


-- ------------------------------
-- 8. Task (tasks) - Membutuhkan Proyek dan Karyawan
-- ------------------------------
CREATE TABLE tasks (
    id_task INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Task',
    nama_task VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,
    prioritas ENUM('low', 'medium', 'high') NOT NULL,
    status ENUM('to do', 'in progress', 'done') NOT NULL,
    deadline DATE NULL,
    id_proyek INT(11) NOT NULL,
    id_karyawan INT(11) NULL, -- Penanggung jawab (boleh null jika belum ditugaskan)
    FOREIGN KEY (id_proyek) REFERENCES projects(id_proyek),
    FOREIGN KEY (id_karyawan) REFERENCES employees(id_karyawan));


-- ------------------------------
-- 9. Deliverable (deliverables) - Membutuhkan Proyek
-- ------------------------------
CREATE TABLE deliverables (
    id_deliverable INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Deliverable',
    nama_deliverable VARCHAR(255) NOT NULL,
    deskripsi TEXT NULL,
    tanggal_dikirim DATE NOT NULL,
    status ENUM('draft', 'final', 'revisi') NOT NULL,
    id_proyek INT(11) NOT NULL,
    FOREIGN KEY (id_proyek) REFERENCES projects(id_proyek));


-- ------------------------------
-- 10. Dokumentasi (documentation) - Membutuhkan Proyek dan Karyawan
-- ------------------------------
CREATE TABLE dokumentasi (
    id_dokumen INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID dokumen',
    judul VARCHAR(255) NOT NULL COMMENT 'Judul dokumen',
    tipe ENUM('manual', 'report', 'design', 'kontrak_tambahan') NULL COMMENT 'Jenis dokumen',
    file_path_link VARCHAR(255) NOT NULL COMMENT 'Path atau link file dokumen',
    tanggal_upload DATETIME NOT NULL COMMENT 'Tanggal upload dokumen',
    id_proyek INT(11) NOT NULL,
    id_karyawan INT(11) NOT NULL,
    FOREIGN KEY (id_proyek) REFERENCES projects(id_proyek),
    FOREIGN KEY (id_karyawan) REFERENCES employees(id_karyawan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;






-- ------------------------------
-- 11. Bug Report (bug_reports) - Membutuhkan Proyek, Karyawan, dan Task
-- ------------------------------
CREATE TABLE laporan_bug (
    id_bug INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'PK Laporan Bug',
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT NOT NULL,
    tingkat_severity ENUM('minor', 'major', 'critical') NOT NULL,
    status ENUM('open', 'in progress', 'resolved', 'closed') NOT NULL,
    tanggal_lapor DATETIME NOT NULL,
    id_proyek INT(11) NOT NULL,
    id_karyawan INT(11) NOT NULL, -- Pelapor bug
    id_task INT(11) NULL, -- Task terkait (opsional)
    FOREIGN KEY (id_proyek) REFERENCES projects(id_proyek),
    FOREIGN KEY (id_karyawan) REFERENCES employees(id_karyawan),
    FOREIGN KEY (id_task) REFERENCES tasks(id_task));


-- Aktifkan kembali pemeriksaan kunci asing
SET FOREIGN_KEY_CHECKS = 1;





